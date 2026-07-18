# Customization

Edit tracked templates in this repository and run `./scripts/install`. Use `./scripts/export-current` only when the live configuration is the source of truth.

Personal skills live under `claude/skills` or `codex/skills`. Skills installed from GitHub belong in `manifests/external-skills.json` unless their license and update strategy make vendoring intentional.

Keep machine-specific MCP servers, trust paths, desktop appearance, and application-managed plugin caches out of the templates. A portable setting should work from `$HOME` on both macOS and Linux or be documented as platform-specific.
