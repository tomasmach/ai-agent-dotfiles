---
name: codex-review
description: Obtain an independent read-only review of a diff, branch or commit using Codex CLI.
---

# Independent Codex review

Select the requested scope and verify it is nonempty before spending a model run. Use one of `--uncommitted`, `--base <branch>` or `--commit <sha>`. Use a custom prompt instead of scope flags when additional focus instructions are needed; check installed CLI help if argument compatibility changes.

The configured model and effort are the defaults. Honor requested overrides and choose effort for the risk without a universal ceiling. Reviewers do not spawn more reviewers.

```bash
artifact_dir="$(mktemp -d "${TMPDIR:-/tmp}/codex-review.XXXXXX")"
codex exec -s read-only review --base "<base>" \
  -o "$artifact_dir/review.md" < /dev/null > "$artifact_dir/run.log" 2>&1
```

Run from the intended worktree. Require findings tied to actual code and a concrete failure scenario. Do not infer success solely from exit code: a review with findings or an empty diff can also exit zero. Inspect the report and log; a missing report is not a clean review.

Relay supported findings and identify any disagreement with evidence. A review-only request does not authorize edits. If repairs were already requested, fix valid findings and verify affected behavior without asking again. Repeat full review only after a materially changed solution; do not rerun a clean review to fish for more findings.

Quiet execution can mean API waiting; inspect the matching session and process before declaring a hang. Do not kill another task's process. On failure report the specific cause and use at most a purposeful corrected retry before selecting another authorized method.
