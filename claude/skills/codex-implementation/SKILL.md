---
name: codex-implementation
description: Hand a bounded implementation from Claude to Codex CLI when that handoff is requested or useful.
---

# Claude to Codex implementation

Use this for a self-contained implementation handoff, not every read, grep or tiny dependent edit. If already running in Codex, do the work directly or use an available bounded subagent instead of recursively invoking this wrapper.

Give the worker the goal, repository/worktree, constraints, agreed interfaces, completion criteria and permitted verification. Preserve current user authorization and exclude production mutations unless explicitly authorized. Independent writers need separate worktrees.

Use the configured model and effort unless the task or user calls for an override; check the CLI's actual model rather than relying on an old label. Do not impose a universal effort ceiling.

```bash
artifact_dir="$(mktemp -d "${TMPDIR:-/tmp}/codex-impl.XXXXXX")"
# Write the bounded task to "$artifact_dir/prompt.md".
codex exec -C "<worktree>" -s workspace-write --add-dir "$artifact_dir" \
  -o "$artifact_dir/report.md" "$(cat "$artifact_dir/prompt.md")" \
  < /dev/null > "$artifact_dir/run.log" 2>&1
```

Inspect the actual diff and verification evidence, not only the final report. Complete already-authorized fixes; rerun only checks whose evidence is missing or invalidated.

For a quiet run, inspect its log, exact session, elapsed time and process state. Low CPU or three minutes without output alone does not prove it is hung. Stop only a task-owned process after evidence of failure; a corrected retry is useful, repeated identical retries are not. If the CLI fails, report the specific failure and continue with an available authorized method when possible.
