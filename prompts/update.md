# Compare and update an existing setup

Use this prompt when the machine already has AI tool configuration:

```text
Compare my current Claude Code, Codex, and (if present) Claudex setup with https://github.com/tomasmach/ai-agent-dotfiles.

Read the repository's README.md and AGENTS.md first. Inspect only relevant local configuration and never display credentials or runtime history. Show me the meaningful differences: missing or changed instructions, personal skills, agents, commands, rules, plugin selections, and portable settings. Distinguish Tomas's authored files from third-party dependencies and check current compatible upstream versions before updating external components.

Apply improvements that are clearly compatible, preserve my unrelated customization, and make a timestamped backup before any replacement. Ask only about genuine conflicts where choosing incorrectly would materially change my workflow. Do not copy machine state or secrets between profiles.

Validate and exercise the resulting setup, then summarize what changed, what stayed local, what was skipped, and any follow-up that requires my login or decision.
```
