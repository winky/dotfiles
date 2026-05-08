#!/usr/bin/env bash
# Verify zsh files parse without errors.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

ROOT=$(dotfiles_root)
findings=""
add() { findings="${findings:+$findings$'\n'}$1"; }

if ! command -v zsh >/dev/null 2>&1; then
  emit_result "02-shell-syntax" "Shell syntax" "warn" \
    "$(finding low "zsh not found, skipping syntax check")"
  exit 0
fi

status="ok"

while IFS= read -r -d '' f; do
  if ! err=$(zsh -n "$f" 2>&1); then
    add "$(finding high "Syntax error in $(basename "$f")" "$err")"
    status="fail"
  fi
done < <(find "$ROOT/.zsh" "$ROOT/.zshrc" -type f \( -name '*.zsh' -o -name '.zshrc' \) -print0 2>/dev/null)

emit_result "02-shell-syntax" "Shell syntax" "$status" "${findings:-[]}"
