# Fresh machine setup

1. Install Git, `jq`, Claude Code, and Codex using their official instructions.
2. Authenticate Claude Code and Codex normally. Do not copy authentication files from another machine.
3. Clone this repository.
4. Run `./scripts/install --dry-run`, inspect the plan, then run `./scripts/install`.
5. Optionally install external skills and plugins from the manifests.
6. Configure Claudex separately if the local CLIProxyAPI profile is needed.
7. Run `./scripts/doctor`.

The installer preserves existing files in a timestamped backup. Project trust prompts, desktop preferences, browser integrations, and OS-specific MCP servers are intentionally configured per machine.
