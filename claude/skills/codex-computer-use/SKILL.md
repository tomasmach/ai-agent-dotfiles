---
name: codex-computer-use
description: Ask Codex CLI (gpt-5.6-sol) to run local app verification that needs computer use, browser automation, simulators, screenshots, app launching, or independent runtime inspection. This is how gpt-5.6-sol is invoked for computer-use work. Use when the user asks Claude to test a flow, verify UI behavior, inspect a running app, capture screenshots, or report confirmation and feedback about implemented behavior that benefits from computer use functionality.
---

# Codex Computer Use

Use Codex as a separate local verification agent when the task needs real UI interaction, screenshots, simulator/browser/device state, or an independent runtime check outside Claude's current context.

Do not use this for ordinary code reading, typechecking, linting, or tests Claude can run directly. Launching apps, simulators, or browsers to verify the requested work is fine without asking; ask first only if the run could disrupt the user's environment beyond that (closing their apps, changing system settings, acting on real accounts or data).

## Workflow

1. Create a temporary artifact directory.
2. Give Codex a self-contained prompt with the repo path, exact flow, constraints, artifact directory, and report format.
3. Run `codex exec` non-interactively.
4. Read Codex's report, inspect or reference screenshot paths, and summarize the result for the user.

Use this command shape:

```bash
ARTIFACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/codex-computer-use.XXXXXX")"
REPORT="$ARTIFACT_DIR/report.md"
PROMPT="$ARTIFACT_DIR/prompt.md"

# Write a self-contained prompt to $PROMPT, then run:
codex exec \
  -C "$PWD" \
  --add-dir "$ARTIFACT_DIR" \
  -s danger-full-access \
  -c model_reasoning_effort="medium" \
  -o "$REPORT" \
  "$(cat "$PROMPT")" \
  < /dev/null > "$ARTIFACT_DIR/run.log" 2>&1
```

Always redirect stdin from `/dev/null` and send output to a log file: with stdin left open (non-TTY) codex can hang at startup forever, and piping stdout (e.g. `| tail`) hides all progress while it runs.

Always pass `-c model_reasoning_effort="<level>"` explicitly (the config default is high, which is usually more than needed): **medium** is the default; **low** for simple scripted flows (launch app, tap through a known path, screenshot); **high** only for genuinely tricky verification (flaky UI, multi-step state, diagnosing why a flow fails). Never above high — no xhigh.

Use `-s danger-full-access` for GUI automation, iOS simulators, desktop app launching, screenshots, or access outside the repo. For non-GUI checks that only need the repo and artifact directory, prefer `-s workspace-write`. Add `--skip-git-repo-check` when the working directory is not a git repository.

## Prompt Requirements

Tell Codex:

- The exact behavior to verify.
- The platform and app type, such as iOS, web, Electron, CLI, or desktop.
- Known launch commands, test credentials, seed data, deep links, or fixtures.
- Whether source edits are allowed. Default to no edits.
- Where screenshots, logs, and the final report should be saved.
- To return pass, fail, or blocked, plus steps performed, observed behavior, screenshot paths, and actionable feedback.

Keep the prompt specific enough that Codex does not need the surrounding Claude conversation.

## Long Runs

Computer-use runs routinely exceed Bash's default timeout. Pass an explicit `timeout` (up to 600000 ms), or run `codex exec` in the background and poll for `$REPORT` to appear. Do not kill and blindly restart a run that is still working — simulator boots and app builds are slow.

## Hung Runs (known failure modes — distinguish from "slow but working")

Two hang modes have been observed with `codex exec`; both look identical from outside (process alive, CPU time near 0:00):

1. **Stdin hang at startup** — no session file ever appears in `~/.codex/sessions/` and nothing happens. Cause: stdin left open when not a TTY. Prevention: always `< /dev/null` (baked into the invocation above).
2. **Hung first API request** — the session file gets a header + `task_started`, then never grows; the process holds an ESTABLISHED TCP connection that never delivers. Codex has no client-side timeout on this request.

Diagnosis before killing anything:

```bash
ps -o pid,etime,time -p <pid>        # long ETIME + TIME near 0:00 ⇒ hung, not thinking
grep -m1 "^session id:" run.log       # printed in the log header
stat -f "%Sm %z" ~/.codex/sessions/YYYY/MM/DD/*<session-id>*.jsonl
```

A working run's session file grows every few seconds (a booting simulator still produces events). Silent for ~3 minutes with ~0 CPU ⇒ dead: kill the process tree and relaunch once with the same prompt. Match the session file by the session id from the log header, not mtime — concurrent codex runs from other projects write to the same directory. For long background runs, arm a watchdog that alerts when the session goes silent instead of waiting for the full timeout. Genuinely slow-but-working runs (simulator boot, app build) keep emitting events and accumulating CPU — leave those alone.

## Reading the Result

- Read `$REPORT` first; treat it as the source of truth, not the raw stdout.
- Open key screenshots with the Read tool when the verdict depends on visual state, and reference their absolute paths in your summary so the user can open them.
- Relay the pass/fail/blocked verdict faithfully. If Codex reports fail, summarize the observed behavior and its feedback — do not soften it or re-verify by assumption.
- If the verdict is blocked (missing credentials, app won't launch, permission dialog), surface what Codex needs and ask the user rather than guessing.

## Failure Handling

- If `codex exec` is missing or errors, report the error text verbatim. Never silently substitute your own inline verification for a computer-use check.
- If the report file is empty or missing after the run, check stdout/stderr from the command before rerunning.
- One targeted rerun with a corrected prompt is fine; repeated identical reruns are not — escalate to the user instead.
- Leave `$ARTIFACT_DIR` in place after the run so the user can inspect screenshots and logs; mention its path in your summary.
