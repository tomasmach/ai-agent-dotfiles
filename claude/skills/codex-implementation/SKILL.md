---
name: codex-implementation
description: Hand an implementation task to Codex CLI (gpt-5.6-sol) — backend code, route handlers, database/schema work, scripts, migrations, data processing, CLI tools, and other clear-spec coding work. This is how gpt-5.6-sol is invoked for implementation. Use when work should go through `codex exec` per the model-picking rules, or when the user asks for a codex/gpt-5.6-sol implementation.
---

# Codex Implementation

Use Codex as a non-interactive implementer: give it a self-contained spec, let it edit the repo, then verify and relay the result. Backend and mechanical work defaults here per the global model-picking rules; UI/copy/API-shape taste calls stay with Claude.

The model comes from `~/.codex/config.toml` (gpt-5.6-sol); do not pass `-m` unless the user asks for a different model.

## Choosing reasoning effort

Always pass `-c model_reasoning_effort="<level>"` explicitly (the config default is high, which is usually more than needed):

- **medium** — the default for implementation tasks.
- **low** — clear-spec/mechanical work (CRUD endpoints, renames, boilerplate, straightforward scripts); Sol is a very good implementer even on low.
- **high** — genuinely hard problems (tricky algorithms, concurrency, subtle refactors across many files).
- **Never above high** — do not use xhigh.

## Running

```bash
ARTIFACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/codex-impl.XXXXXX")"
REPORT="$ARTIFACT_DIR/report.md"
PROMPT="$ARTIFACT_DIR/prompt.md"

# Write a self-contained prompt to $PROMPT, then run:
codex exec \
  -C "<repo root>" \
  --add-dir "$ARTIFACT_DIR" \
  -s workspace-write \
  -c model_reasoning_effort="medium" \
  -o "$REPORT" \
  "$(cat "$PROMPT")" \
  < /dev/null > "$ARTIFACT_DIR/run.log" 2>&1
```

- **Always redirect stdin from `/dev/null` and send output to a log file**: with stdin left open (non-TTY) codex can hang at startup forever; piping stdout (e.g. `| tail`) hides all progress.
- `-s workspace-write` is the right sandbox for implementation. Add `--skip-git-repo-check` outside a git repo.
- Parallel codex implementation runs must work in separate git worktrees — edits in a shared checkout collide.

## Prompt requirements

Codex has no access to the surrounding Claude conversation, so the prompt must stand alone:

- The exact change to make, with acceptance criteria.
- Relevant file paths, conventions, and constraints (framework, style, "don't touch X").
- Any interface decisions already made (route shape, naming, types) — Codex implements them, it does not redesign them.
- How to verify: which tests/build/lint commands to run before declaring done.
- Report format: what changed (file list), how it was verified, and anything left open — written as the final message (captured in `$REPORT`).

## Long runs

Implementation runs can exceed Bash's default timeout. Pass an explicit `timeout` (up to 600000 ms), or run in the background and poll for `$REPORT`. Do not kill and blindly restart a run that is still working — builds and test suites are slow.

## Hung runs (known failure modes — distinguish from "slow but working")

Two hang modes have been observed with `codex exec`; both look identical from outside (process alive, CPU time near 0:00):

1. **Stdin hang at startup** — no session file ever appears in `~/.codex/sessions/` and nothing happens. Cause: stdin left open when not a TTY. Prevention: always `< /dev/null` (baked into the invocation above).
2. **Hung first API request** — the session file gets a header + `task_started`, then never grows; the process holds an ESTABLISHED TCP connection that never delivers. Codex has no client-side timeout on this request.

Diagnosis before killing anything:

```bash
ps -o pid,etime,time -p <pid>        # long ETIME + TIME near 0:00 ⇒ hung, not thinking
grep -m1 "^session id:" run.log       # printed in the log header
stat -f "%Sm %z" ~/.codex/sessions/YYYY/MM/DD/*<session-id>*.jsonl
```

A working run's session file grows every few seconds. Silent for ~3 minutes with ~0 CPU ⇒ dead: kill the process tree and relaunch once with the same prompt. Match the session file by the session id from the log header, not mtime — concurrent codex runs from other projects write to the same directory.

## After the run

- Read `$REPORT`, then check the actual diff (`git status` / `git diff --stat`) — the diff is the ground truth, not the report.
- Run the verification commands yourself (tests, typecheck, build) if the report doesn't show they were run. Broken state doesn't ship on Codex's word alone.
- Summarize for the user: what changed, how it was verified, and any open questions from the report.

## Failure handling

- If `codex exec` is missing or errors, report the error text verbatim. Only fall back to implementing inline after telling the user Codex failed.
- If the result misses the bar (wrong approach, failed tests), one targeted rerun with a corrected, more specific prompt is fine; after that, escalate or take over inline per the standing override rule.
- Auth errors → suggest the user runs `! codex login`.
