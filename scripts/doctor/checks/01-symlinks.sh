#!/usr/bin/env bash
# Detect broken symlinks pointing into the dotfiles repo from $HOME.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

ROOT=$(dotfiles_root)

# Find dead symlinks at $HOME top level and ~/.config that point at this repo.
findings=""
add() {
  if [[ -z "$findings" ]]; then findings="$1"; else findings="$findings"$'\n'"$1"; fi
}

scan_dir() {
  local dir="$1" depth="$2"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r -d '' link; do
    target=$(readlink "$link" 2>/dev/null || true)
    [[ -z "$target" ]] && continue
    # Resolve to absolute target
    case "$target" in
      /*) abs_target="$target" ;;
      *)  abs_target="$(cd "$(dirname "$link")" && cd "$(dirname "$target")" 2>/dev/null && pwd)/$(basename "$target")" || abs_target="$target" ;;
    esac
    # Only report links that target this dotfiles repo
    if [[ "$abs_target" == "$ROOT"/* ]] && [[ ! -e "$link" ]]; then
      add "$(finding high "Dead symlink: $link" "Target missing: $target")"
    fi
  done < <(find "$dir" -maxdepth "$depth" -type l -print0 2>/dev/null)
}

scan_dir "$HOME" 1
scan_dir "$HOME/.config" 2

if [[ -z "$findings" ]]; then
  emit_result "01-symlinks" "Symlink integrity" "ok" "[]"
else
  emit_result "01-symlinks" "Symlink integrity" "fail" "$findings"
fi
