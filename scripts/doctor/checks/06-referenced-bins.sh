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

# Optional commands are only meaningful on a real workstation; CI runners
# are not expected to have them installed, so skip to avoid false warnings.
if [[ -n "${CI:-}" ]]; then
  add "$(finding low "Skipped optional command check" "Running in CI; optional tools are not expected on the runner.")"
else
  for cmd in "${optional[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      add "$(finding low "Optional command not installed: $cmd" "Some features may be unavailable.")"
      [[ "$status" == "ok" ]] && status="warn"
    fi
  done
fi

emit_result "06-referenced-bins" "Referenced commands" "$status" "${findings:-[]}"
