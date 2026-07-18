# Security model

This is a public configuration repository, not a home-directory backup.

## Never export

- API keys, auth tokens, passwords, cookies, OAuth files, SSH keys
- Claude `.claude.json` machine state
- Codex `auth.json`, SQLite databases, memories, goals, logs, sessions, attachments, or generated images
- Claude/Claudex histories, sessions, projects, telemetry, caches, backups, teams, or paste buffers
- CLIProxyAPI config and account JSON files
- private repository contents or application data

The export command copies only explicit paths. Adding a source requires editing the allowlist in `scripts/export-current` and its matching test.

## Before publishing

```bash
./scripts/secret-scan
git status --short
git diff --cached
git ls-files
```

The scanner is a defense-in-depth check, not a proof that a repository is safe. Review business-sensitive instructions, private hostnames, email addresses, and personal paths manually too.

If a secret was committed, revoke it first. Rewriting Git history does not invalidate a credential already copied by someone else.

## Claudex credentials

The `claudex` wrapper reads `~/.config/claudex/env`, which must be mode `0600`. The tracked example contains no working token. CLIProxyAPI's own configuration and OAuth account file remain outside this repository.

## Backups

The installer stores replaced files beneath `~/.local/state/ai-agent-dotfiles/backups/<timestamp>/`. Backups may contain older private configuration, so they are never placed inside the repository.
