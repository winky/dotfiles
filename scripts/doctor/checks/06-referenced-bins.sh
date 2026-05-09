#!/usr/bin/env bash
# Verify external commands referenced in shell config exist on PATH.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

ROOT=$(dotfiles_root)

# Curated list of commands the dotfiles depend on. Add to this as needed.
required=(zsh git)
optional=(fzf gh ghq tmux nvim vim asdf jq)

findings=""
add() { findings="${findings:+$findings$'\n'}$1"; }
status="ok"

for cmd in "${required[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    add "$(finding high "Missing required command: $cmd")"
    status="fail"
  fi
done

for cmd in "${optional[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    add "$(finding low "Optional command not installed: $cmd" "Some features may be unavailable.")"
    [[ "$status" == "ok" ]] && status="warn"
  fi
done

emit_result "06-referenced-bins" "Referenced commands" "$status" "${findings:-[]}"
