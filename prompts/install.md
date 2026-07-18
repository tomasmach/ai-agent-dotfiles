# Install with an AI agent

Use this prompt with an agent that can read files and operate the terminal:

```text
Install the appropriate parts of https://github.com/tomasmach/ai-agent-dotfiles on this machine.

Start by reading README.md and AGENTS.md in that repository. Inspect my operating system, installed AI coding tools, shells, and existing Claude Code/Codex/Claudex configuration. Do not print or copy credentials, histories, sessions, caches, databases, or machine state.

Recommend the applicable components, then carry out the installation without making me choose every individual file. Merge with my existing instructions and settings instead of blindly overwriting them. Adapt paths and platform-specific configuration, make a timestamped backup before changing existing files, and install third-party skills/plugins from their upstream sources rather than copying runtime caches.

Do not install Claudex or CLIProxyAPI unless I already use it or explicitly confirm that I want it. Never create or move secrets on my behalf; tell me where I must authenticate or add a private value locally.

Afterward, validate changed JSON/TOML, verify that the installed agents/skills/rules/plugins are discoverable, run the relevant doctor checks, and exercise a harmless real prompt through each configured CLI. Give me a concise report of what you installed, merged, skipped, backed up, and verified.
```
