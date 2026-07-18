---
name: codex-review
description: Run a code review with Codex CLI (gpt-5.6-sol) over uncommitted changes, a branch diff, or a single commit. This is how gpt-5.6-sol is invoked for review work. Use when the user asks for a codex review, a gpt-5.6-sol review, a second-opinion review of a diff/branch/commit, or when a plan/implementation review should include an independent gpt-5.6-sol perspective.
---

# Codex Review

Use Codex as an independent, non-interactive reviewer. It reads the repo itself and returns prioritized findings; it never edits files. The deliverable is the findings report — do not apply fixes unless the user asks.

Always use `codex exec review` (not top-level `codex review`): only the `exec` form supports `-o`/`--json` for reliable output capture. The model comes from `~/.codex/config.toml` (gpt-5.6-sol); do not pass `-m` unless the user asks for a different model.

## Choosing reasoning effort

Always pass `-c model_reasoning_effort="<level>"` explicitly (the config default is high, which is usually more than needed):

- **medium** — the default for reviews.
- **low** — small/mechanical diffs (renames, config changes, straightforward CRUD); Sol is strong even on low.
- **high** — large, subtle, or high-stakes diffs (concurrency, auth, data migrations) or when the user asks for a thorough review.
- **Never above high** — do not use xhigh.

## Choosing the scope

Exactly one of these, based on what the user wants reviewed:

| Scope | Flag | Use for |
|---|---|---|
| Working tree | `--uncommitted` | staged + unstaged + untracked changes |
| Branch | `--base <branch>` | everything on the current branch vs a base (PR-style) |
| Commit | `--commit <SHA>` | a single commit |

**Scope flags and a custom `[PROMPT]` are mutually exclusive** — the CLI errors out if you combine them. To pass custom instructions (focus areas, ignore rules, severity bar), drop the scope flag and state the scope in the prompt text instead, e.g. `"Review the uncommitted changes. Focus only on concurrency bugs."`. Codex resolves the scope from the prose and respects the focus.

## Pre-flight checks (before spending a model run)

1. Confirm you're in a git repo (`git rev-parse --git-dir`). Review scopes are git-based; outside a repo there is nothing meaningful to review.
2. Confirm the diff is non-empty for the chosen scope:
   - `--uncommitted` → `git status --porcelain` has output
   - `--base X` → `git diff X...HEAD --stat` has output (and branch `X` exists)
   - `--commit SHA` → the SHA resolves (`git rev-parse SHA^{commit}`)

   An empty diff is NOT an error in codex — it still runs a full model turn and exits 0 with a prose message like "There are no … changes to review". Checking first saves the run; if the diff is empty, tell the user instead of invoking codex.

## Running

```bash
ARTIFACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/codex-review.XXXXXX")"
REVIEW="$ARTIFACT_DIR/review.md"

codex exec review \
  --uncommitted \
  -c model_reasoning_effort="medium" \
  -o "$REVIEW" \
  --title "short description of the change"
# or: --base main | --commit abc123 | no flag + custom prompt
```

- Run from the repo root, or pass `-C <repo>`.
- `--title` is optional context shown in the summary; use the change's intent (helps codex judge against purpose).
- Large diffs can exceed Bash's default timeout. Pass an explicit `timeout` (up to 600000 ms), or run in the background and poll for `$REVIEW`. Do not kill and restart a run that is still working.
- **Always redirect stdin and capture output to a file**: `codex exec review … < /dev/null > "$ARTIFACT_DIR/run.log" 2>&1`. With stdin left open (non-TTY) codex can hang at startup forever; piping stdout (e.g. `| tail`) hides all progress.

## Hung runs (known failure modes — check before assuming "still working")

Two distinct hang modes have been observed; both look the same from outside (process alive, ~0 CPU):

1. **Stdin hang at startup** — codex never creates a session in `~/.codex/sessions/` and does no work. Cause: stdin left open when not a TTY. Prevention: always `< /dev/null` (see above).
2. **Hung first API request** — the session file gets a header + `task_started` and then never grows; `lsof` shows an ESTABLISHED TCP connection to the API that never delivers. Codex has no client-side timeout on this request, so it waits forever.

**Diagnosis** (run when a codex process has been quiet suspiciously long):
```bash
ps -o pid,etime,time -p <pid>       # long ETIME + TIME near 0:00 ⇒ hung, not thinking
grep -m1 "^session id:" run.log      # session id is printed in the log header
stat -f "%Sm %z" ~/.codex/sessions/YYYY/MM/DD/*<session-id>*.jsonl
```
A working run's session file grows every few seconds. If it hasn't changed for ~3 minutes and CPU time is near zero, the run is dead: kill the process tree and relaunch once with the same prompt (sessions are cheap; the relaunch almost always goes through). For long runs, arm a watchdog that alerts when the session file goes silent >3 min instead of waiting on the final timeout. Match the session file by the session id from the log header, not by mtime — concurrent codex runs from other projects also write to `~/.codex/sessions/`.

## Reading the result

Read `$REVIEW` (the last agent message) — it is the source of truth; stdout duplicates it with exec noise mixed in.

Successful review format: a one-line summary, then a comments section with bullets shaped like:

```
- [P2] Short imperative title — /abs/path/file.py:7-8
  Explanation with concrete failure scenario.
```

- Priorities: `[P1]` blocking/urgent, `[P2]` important, `[P3]` minor.
- The header varies ("Full review comments:" / "Review comment:") — detect findings by the `[P` bullets, not the header text.
- Paths are absolute; convert to repo-relative `file:line` when relaying to the user.

## No findings — expected, not a failure

Exit code is 0 whether codex finds 10 issues or none. A clean review is a prose message with **no `[P` bullets** (e.g. a positive summary, or "no changes to review" if the diff was empty despite pre-flight). Handle it as:

- Report it plainly as a clean review — quote codex's summary sentence.
- Do NOT rerun to fish for issues, lower the bar, or substitute your own inline review to "find something".
- Do NOT confuse it with a failed run: failure means nonzero exit, missing/empty `$REVIEW` file, or auth/CLI errors on stderr.

## Failure handling

- Nonzero exit or missing `$REVIEW` → read stdout/stderr and report the error text verbatim. Never silently substitute your own review for the codex run.
- `--uncommitted cannot be used with [PROMPT]`-style arg errors → you combined a scope flag with custom instructions; move the scope into the prompt.
- Auth errors → suggest the user runs `! codex login`.
- One targeted rerun with a corrected invocation is fine; repeated identical reruns are not — escalate to the user.

## Presenting findings

- Lead with the verdict (clean / N findings, highest priority first).
- Relay every finding faithfully with its priority, repo-relative location, and codex's failure scenario — do not soften, drop, or re-adjudicate findings by assumption. If you independently disagree with one, say so explicitly as your own assessment alongside codex's.
- Offer to fix the findings as a follow-up; apply them only when the user asks.
