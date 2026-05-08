#!/usr/bin/env bash
# Validate tmux config syntax.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

ROOT=$(dotfiles_root)
CONF="$ROOT/.tmux.conf"

if [[ ! -f "$CONF" ]]; then
  emit_result "04-tmux-syntax" "tmux config syntax" "ok" "[]"
  exit 0
fi

if ! command -v tmux >/dev/null 2>&1; then
  emit_result "04-tmux-syntax" "tmux config syntax" "warn" \
    "$(finding low "tmux not found, skipping syntax check")"
  exit 0
fi

# Use a private socket path under TMPDIR so we don't fight with the user's tmux.
sock_dir="${TMPDIR:-/tmp}/dotfiles-doctor-tmux-$$"
mkdir -p "$sock_dir"
trap 'rm -rf "$sock_dir"' EXIT
sock="$sock_dir/sock"

err=$(tmux -S "$sock" -f "$CONF" start-server 2>&1 >/dev/null || true)
tmux -S "$sock" kill-server 2>/dev/null || true

if [[ -z "$err" ]]; then
  emit_result "04-tmux-syntax" "tmux config syntax" "ok" "[]"
elif printf '%s' "$err" | grep -qE 'creating|couldn.t create directory|Operation not permitted'; then
  # Environment-level failure, not a real config issue.
  emit_result "04-tmux-syntax" "tmux config syntax" "warn" \
    "$(finding low "could not start tmux server to validate config" "$err")"
else
  emit_result "04-tmux-syntax" "tmux config syntax" "fail" \
    "$(finding high "tmux config has errors" "$err")"
fi
