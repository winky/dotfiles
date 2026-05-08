#!/usr/bin/env bash
# Shared helpers for doctor checks.
# Each check script sources this and emits a JSON object on stdout.

set -euo pipefail

if [[ -t 2 ]]; then
  C_RESET=$'\033[0m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  C_GREEN=$'\033[32m'
  C_BLUE=$'\033[34m'
  C_DIM=$'\033[2m'
else
  C_RESET=""; C_RED=""; C_YELLOW=""; C_GREEN=""; C_BLUE=""; C_DIM=""
fi

log_info()  { printf '%s[info]%s  %s\n' "$C_BLUE"   "$C_RESET" "$*" >&2; }
log_warn()  { printf '%s[warn]%s  %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
log_error() { printf '%s[error]%s %s\n' "$C_RED"    "$C_RESET" "$*" >&2; }
log_ok()    { printf '%s[ok]%s    %s\n' "$C_GREEN"  "$C_RESET" "$*" >&2; }

# Build a finding JSON object.
# Usage: finding <severity> <message> [details]
finding() {
  local severity="$1" message="$2" details="${3:-}"
  jq -nc \
    --arg severity "$severity" \
    --arg message  "$message" \
    --arg details  "$details" \
    '{severity: $severity, message: $message} + (if $details != "" then {details: $details} else {} end)'
}

# Emit the final check result JSON.
# Usage: emit_result <id> <title> <status> <findings_jsonl_or_array>
# findings can be either a JSON array or newline-separated JSON objects.
emit_result() {
  local id="$1" title="$2" status="$3" findings_input="${4:-}"

  local findings_array='[]'
  if [[ -n "$findings_input" ]]; then
    if [[ "$findings_input" == \[* ]]; then
      findings_array="$findings_input"
    else
      findings_array=$(printf '%s\n' "$findings_input" | jq -sc '.')
    fi
  fi

  jq -nc \
    --arg id     "$id" \
    --arg title  "$title" \
    --arg status "$status" \
    --argjson findings "$findings_array" \
    '{id: $id, title: $title, status: $status, findings: $findings}'
}

# Resolve dotfiles repo root from any check script.
dotfiles_root() {
  local self="${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}"
  local dir
  dir=$(cd "$(dirname "$self")" && pwd)
  # checks live at scripts/doctor/checks/, lib.sh at scripts/doctor/
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/Makefile" && -d "$dir/.zsh" ]]; then
      printf '%s' "$dir"
      return
    fi
    dir=$(dirname "$dir")
  done
  log_error "could not locate dotfiles root from $self"
  return 1
}
