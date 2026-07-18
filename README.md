# AI agent dotfiles

Portable, public-safe configuration for the AI coding tools I use on macOS and Linux:

- Claude Code
- OpenAI Codex
- Claudex, a separate Claude Code profile routed through CLIProxyAPI

The repository stores authored instructions, agents, skills, rules, sanitized configuration templates, and reproducible setup helpers. Credentials, histories, caches, machine identifiers, and application-managed runtime files are deliberately excluded.

## Give it to your agent

You are not expected to install these dotfiles by hand. Point an AI coding agent at this repository and let it inspect your existing setup, explain the available pieces, and adapt the useful parts to your machine.

Paste this:

```text
Open https://github.com/tomasmach/ai-agent-dotfiles and read README.md and AGENTS.md.
First inspect my existing AI coding setup and explain which parts of this repository are relevant to me. Then install the compatible parts I approve, merging with my current configuration instead of replacing it blindly. Back up changed files, never copy or expose credentials/runtime state, adapt everything to my OS, and verify each configured CLI with a harmless real prompt when finished.
```

Ready-made prompts:

- [Understand the setup before changing anything](prompts/explain.md)
- [Install the appropriate parts on a new machine](prompts/install.md)
- [Compare and update an existing setup](prompts/update.md)

The root [AGENTS.md](AGENTS.md) tells an agent how to inspect, merge, back up, install, and verify the setup safely. External skills and plugins are references to their upstream projects, not vendored copies.

## Repository map

```text
claude/      Claude Code instructions, settings template, custom agents and skills
codex/       Codex instructions, rules, config template and custom skills
claudex/     Isolated Claudex profile plus launchd/systemd templates
manifests/   External skills and plugin provenance
scripts/     Install, update, export, doctor and secret-scan commands
prompts/     Copy-paste requests for exploring, installing, and updating
docs/        Platform setup, security and customization notes
tests/       Offline smoke tests for the shell tooling
```

## What an agent should do

An agent installing this setup should:

- inspect the tools and configuration already present;
- recommend only compatible components;
- merge instructions and portable settings instead of overwriting blindly;
- back up every replaced file;
- fetch third-party skills/plugins from their upstream projects;
- keep credentials and application-managed state local;
- verify the real Claude Code, Codex, or Claudex flow afterward.

The shell scripts are helpers for the agent and for repository maintenance. They are deliberately not the primary onboarding experience.

## Updating this repository

Ask your agent to export current portable changes, review the diff, run the secret scan, and publish a conventional commit. The export helper is allowlist-based and excludes `auth.json`, `.claude.json`, histories, sessions, databases, plugin caches, OAuth files, and CLIProxyAPI credentials.

## Claudex

Claudex uses its own `CLAUDE_CONFIG_DIR`, a local CLIProxyAPI endpoint, and private machine-local credentials. Let the installing agent create the profile and tell you exactly when a private value or authentication step is required. See [docs/claudex.md](docs/claudex.md) for the underlying proxy setup and service templates.

## Safety and ownership

- Never commit secrets. The included scanner performs pattern, entropy-oriented, filename, and tracked-file checks.
- External work remains under its upstream license. This repository records source and version information instead of relicensing it.
- The root MIT license covers original material in this repository only.
- Machine-specific trust state and project paths are rebuilt locally, not published.

Read [docs/security.md](docs/security.md) before making the repository public or adding a new configuration source.

## Supported systems

- macOS with Bash 3.2+, Zsh, Git, `jq`, Claude Code, Codex, and optionally Homebrew
- Linux (including Nobara) with Bash, Git, `jq`, Claude Code, Codex, and optionally user systemd

The repository does not assume every machine should receive every component. Its agent instructions explicitly require environment discovery and selective installation.

## License

Original content is available under the [MIT License](LICENSE). Third-party tools and manifest entries retain their own licenses.
