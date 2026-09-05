---
name: codex-computer-use
description: Hand a local browser or simulator verification from Claude to Codex CLI when an independent UI worker is useful.
---

# Claude to Codex runtime verification

Use an available direct browser/device tool when it already handles the task. This wrapper is a Claude-to-Codex handoff, not a reason for Codex to delegate recursively or for code review to use the GitHub GUI.

Give the worker the exact flow, environment, platform, existing process/worktree, test-data constraints, artifact directory and allowed edits (default none). Require observed results and screenshots. Preserve the user's processes and use fixture accounts only in the authorized environment; no live store writes for Uprate.

Respect platform capabilities: iOS simulator runs on macOS; on Linux verify the backend or an available Android emulator and identify iOS as unverified. Do not launch EAS builds for Mach.

Use the configured model and effort unless the task needs an explicit override. Capture final output and logs, redirect stdin, and choose the available permission mode appropriate to the authorized tools rather than bypassing protections by default.

```bash
artifact_dir="$(mktemp -d "${TMPDIR:-/tmp}/codex-ui.XXXXXX")"
# Write the exact scenario to "$artifact_dir/prompt.md".
codex exec -C "<worktree>" --add-dir "$artifact_dir" \
  -o "$artifact_dir/report.md" "$(cat "$artifact_dir/prompt.md")" \
  < /dev/null > "$artifact_dir/run.log" 2>&1
```

Read the report and inspect the screenshots yourself. Distinguish passed, failed and unverified steps; a report alone is not proof of the result. If blocked, complete independent authorized work and name the actual missing capability. For quiet runs inspect logs and the matching session; silence or low CPU alone is not a reason to kill it. Keep useful artifacts for the user.
