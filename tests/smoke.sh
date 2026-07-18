#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
temp_root="$(mktemp -d)"
trap 'rm -rf "$temp_root"' EXIT
export HOME="$temp_root/home"
mkdir -p "$HOME/.claude" "$HOME/.codex" "$HOME/.claudex"
printf 'old configuration\n' > "$HOME/.claude/CLAUDE.md"

"$root/scripts/install" >/dev/null

test -f "$HOME/.claude/CLAUDE.md"
test -f "$HOME/.claude/settings.json"
test -f "$HOME/.claude/agents/uprate-codebase-analyzer.md"
test -f "$HOME/.claude/commands/uprate/aso-audit.md"
test -f "$HOME/.claude/skills/verify/SKILL.md"
test -f "$HOME/.codex/AGENTS.md"
test -f "$HOME/.codex/config.toml"
test -f "$HOME/.codex/rules/default.rules"
test -f "$HOME/.codex/skills/html-plan/SKILL.md"
test -f "$HOME/.claudex/CLAUDE.md"
test -f "$HOME/.claudex/settings.json"
test -x "$HOME/.local/bin/claudex"
test -L "$HOME/.claudex/skills/verify"
test -f "$HOME/.local/state/ai-agent-dotfiles/backups/"*/.claude/CLAUDE.md

if grep -R '__HOME__' "$HOME/.claude/CLAUDE.md" "$HOME/.claude/settings.json" "$HOME/.codex" "$HOME/.claudex/CLAUDE.md" "$HOME/.claudex/settings.json" >/dev/null; then
  printf 'unrendered __HOME__ placeholder found\n' >&2
  exit 1
fi

jq empty "$HOME/.claude/settings.json"
jq empty "$HOME/.claudex/settings.json"
grep -F "$HOME/.codex/AGENTS.md" "$HOME/.claudex/CLAUDE.md" >/dev/null

printf 'Smoke test passed.\n'
