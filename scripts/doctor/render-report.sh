#!/usr/bin/env bash
# Render aggregated check JSON (stdin) into Markdown (stdout).
#
# Input shape: { "timestamp", "host", "checks": [ { id, title, status, findings: [...] } ] }

set -euo pipefail

input=$(cat)

# Status emoji
emoji() {
  case "$1" in
    ok)   printf '✅' ;;
    warn) printf '⚠️ ' ;;
    fail) printf '❌' ;;
    *)    printf '❓' ;;
  esac
}

timestamp=$(printf '%s' "$input" | jq -r '.timestamp')
host=$(printf '%s' "$input" | jq -r '.host')

ok_count=$(printf '%s' "$input" | jq '[.checks[] | select(.status == "ok")] | length')
warn_count=$(printf '%s' "$input" | jq '[.checks[] | select(.status == "warn")] | length')
fail_count=$(printf '%s' "$input" | jq '[.checks[] | select(.status == "fail")] | length')

cat <<MD
# Dotfiles Health Report

- **Generated:** $timestamp
- **Host:** $host
- **Summary:** ✅ $ok_count ok / ⚠️ $warn_count warn / ❌ $fail_count fail

## Checks

MD

# Iterate checks
printf '%s' "$input" | jq -c '.checks[]' | while read -r check; do
  id=$(printf '%s' "$check" | jq -r '.id')
  title=$(printf '%s' "$check" | jq -r '.title')
  status=$(printf '%s' "$check" | jq -r '.status')
  e=$(emoji "$status")
  printf '### %s %s — %s\n\n' "$e" "$title" "$id"

  findings_len=$(printf '%s' "$check" | jq '.findings | length')
  if [[ "$findings_len" == "0" ]]; then
    printf 'No findings.\n\n'
    continue
  fi

  printf '%s' "$check" | jq -c '.findings[]' | while read -r f; do
    sev=$(printf '%s' "$f" | jq -r '.severity')
    msg=$(printf '%s' "$f" | jq -r '.message')
    details=$(printf '%s' "$f" | jq -r '.details // empty')
    case "$sev" in
      high)   sev_label='**[high]**' ;;
      medium) sev_label='**[medium]**' ;;
      low)    sev_label='[low]' ;;
      *)      sev_label='[info]' ;;
    esac
    printf -- '- %s %s' "$sev_label" "$msg"
    if [[ -n "$details" ]]; then
      # Indent multi-line details under the bullet
      printf '\n'
      printf '%s' "$details" | sed 's/^/    /'
      printf '\n'
    else
      printf '\n'
    fi
  done
  printf '\n'
done
