#!/usr/bin/env bash

repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

timestamp() {
  date -u '+%Y%m%dT%H%M%SZ'
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'missing required command: %s\n' "$1" >&2
    return 1
  fi
}

render_template() {
  local source="$1" destination="$2"
  sed "s|__HOME__|$HOME|g" "$source" > "$destination"
}

portable_copy() {
  local source="$1" destination="$2" backup_root="$3" dry_run="$4"
  if [[ ! -e "$source" ]]; then
    return 0
  fi
  if [[ "$dry_run" == "1" ]]; then
    printf 'install %s -> %s\n' "$source" "$destination"
    return 0
  fi
  mkdir -p "$(dirname "$destination")"
  if [[ -e "$destination" || -L "$destination" ]]; then
    local relative="${destination#$HOME/}"
    mkdir -p "$backup_root/$(dirname "$relative")"
    cp -R "$destination" "$backup_root/$relative"
  fi
  rm -rf "$destination"
  cp -R "$source" "$destination"
}

portable_template() {
  local source="$1" destination="$2" backup_root="$3" dry_run="$4"
  if [[ "$dry_run" == "1" ]]; then
    printf 'render %s -> %s\n' "$source" "$destination"
    return 0
  fi
  local temp_file
  temp_file="$(mktemp)"
  render_template "$source" "$temp_file"
  portable_copy "$temp_file" "$destination" "$backup_root" "0"
  rm -f "$temp_file"
}
