# Instructions for AI agents

This repository is designed to be understood and installed by an AI coding agent. Treat it as a reference configuration, not as a directory that should be copied wholesale into the user's home folder.

## First determine the task

The user may want one of four things:

1. An explanation of what Tomas uses and why.
2. A fresh installation on the current machine.
3. An update or comparison against an existing setup.
4. Only selected skills, agents, rules, or workflows.

If the request is exploratory, remain read-only. If the user asks to install or update, inspect the current machine and carry the work through verification.

## Before changing anything

1. Read `README.md`, this file, and the relevant platform documentation.
2. Detect the operating system, shell, installed AI tools, and their actual config paths.
3. Inspect existing Claude Code, Codex, and Claudex configuration without printing credentials.
4. Compare existing files with this repository. Preserve unrelated user customization.
5. Decide which components apply. Do not install Claudex or CLIProxyAPI unless the user wants that profile.
6. Make a timestamped backup outside the repository before replacing or merging any existing file.

Do not ask the user to choose every file. Make sensible recommendations from the detected environment and explain any meaningful tradeoff. Ask only when a conflict would materially change their setup or new credentials/authority are required.

## Installation model

- Merge human-authored global instructions from `claude/CLAUDE.md` and `codex/AGENTS.md` with existing instructions. Do not silently erase local rules.
- Render `__HOME__` placeholders using the real home directory.
- Treat `*.template.json` and `*.template.toml` as sanitized references. Retain valid machine-specific settings and remove platform-incompatible entries.
- Install personal agents, commands, rules, and skills from the matching tool directory.
- Use `manifests/` to identify third-party skills and plugins. Install them from upstream with their supported installer rather than copying caches from this repository. Check the current compatible release before adding a dependency.
- Never vendor Codex system skills, managed runtime skills, plugin caches, browser integrations, or desktop application state.
- The scripts under `scripts/` are implementation helpers. Inspect them before use; they are not a substitute for understanding the target machine.

## Files that must never be copied or requested

- API keys, tokens, passwords, cookies, OAuth credentials, SSH keys
- `.claude.json`, `auth.json`, CLIProxyAPI account JSON, or private proxy config
- histories, sessions, project state, telemetry, caches, backups, paste buffers
- SQLite databases, memories, goals, logs, attachments, generated images
- machine IDs, trust state, or another machine's absolute project paths

Authentication must be performed normally on the destination machine. For Claudex, create the private environment/config files locally and let the user provide credentials without displaying or committing them.

## Verification

After an installation or update:

1. Parse all changed JSON and TOML files.
2. Confirm expected instructions, agents, commands, rules, and skills resolve from the target config directories.
3. Run `scripts/doctor` when applicable and independently inspect anything it cannot check.
4. Launch a harmless one-shot prompt through each configured CLI the user intends to use.
5. Confirm no new warnings caused by missing hooks, commands, plugins, paths, or services.
6. Run `scripts/secret-scan` if the repository itself changed.
7. Report what was installed, merged, skipped, backed up, and verified.

Never claim completion based only on copied files or a passing syntax check.
