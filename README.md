# AI agent dotfiles

Portable, public-safe configuration for the AI coding tools I use on macOS and Linux:

- Claude Code
- OpenAI Codex
- Claudex, a separate Claude Code profile routed through CLIProxyAPI

The repository stores authored instructions, agents, skills, rules, sanitized configuration templates, and reproducible setup scripts. Credentials, histories, caches, machine identifiers, and application-managed runtime files are deliberately excluded.

## Quick start

```bash
git clone https://github.com/tomasmach/ai-agent-dotfiles.git
cd ai-agent-dotfiles
./scripts/install
./scripts/doctor
```

The installer creates timestamped backups before changing an existing file. It installs portable files into `~/.claude`, `~/.codex`, and `~/.claudex`; shared personal skills are linked into both Claude profiles. Use `--dry-run` to inspect every action first.

```bash
./scripts/install --dry-run
./scripts/install --with-external-skills
```

External skills and plugins are references to their upstream projects, not vendored copies. Review [the manifests](manifests/) and install only the pieces you want.

## Repository map

```text
claude/      Claude Code instructions, settings template, custom agents and skills
codex/       Codex instructions, rules, config template and custom skills
claudex/     Isolated Claudex profile plus launchd/systemd templates
manifests/   External skills and plugin provenance
scripts/     Install, update, export, doctor and secret-scan commands
docs/        Platform setup, security and customization notes
tests/       Offline smoke tests for the shell tooling
```

## Day-to-day use

Export the current portable configuration back into a checkout:

```bash
./scripts/export-current
./scripts/secret-scan
git diff
```

Update a machine from the repository:

```bash
./scripts/update
```

The export script is intentionally allowlist-based. It will not copy `auth.json`, `.claude.json`, histories, sessions, databases, plugin caches, OAuth files, or CLIProxyAPI credentials.

## Claudex

Claudex uses its own `CLAUDE_CONFIG_DIR` and a local CLIProxyAPI endpoint. Put its token in a private environment file:

```bash
mkdir -p ~/.config/claudex
printf '%s\n' 'ANTHROPIC_AUTH_TOKEN=replace-me' > ~/.config/claudex/env
chmod 600 ~/.config/claudex/env
```

Then install the profile and run `claudex`. See [docs/claudex.md](docs/claudex.md) for proxy setup and service templates.

## Safety and ownership

- Never commit secrets. `./scripts/secret-scan` runs pattern, entropy-oriented, filename, and tracked-file checks.
- External work remains under its upstream license. This repository records source and version information instead of relicensing it.
- The root MIT license covers original material in this repository only.
- Machine-specific trust state and project paths are rebuilt locally, not published.

Read [docs/security.md](docs/security.md) before making the repository public or adding a new configuration source.

## Supported systems

- macOS with Bash 3.2+, Zsh, Git, `jq`, Claude Code, Codex, and optionally Homebrew
- Linux (including Nobara) with Bash, Git, `jq`, Claude Code, Codex, and optionally user systemd

The scripts do not install Claude Code, Codex, or CLIProxyAPI automatically. They configure already-installed tools and explain missing prerequisites.

## License

Original content is available under the [MIT License](LICENSE). Third-party tools and manifest entries retain their own licenses.
