#!/usr/bin/env bash
# Sanity-check git configuration in the dotfiles repo.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

ROOT=$(dotfiles_root)
GITCFG="$ROOT/config/git/config"

findings=""
add() { findings="${findings:+$findings$'\n'}$1"; }
status="ok"

if [[ ! -f "$GITCFG" ]]; then
  emit_result "07-git-config" "Git config" "warn" \
    "$(finding low "config/git/config not found, skipping")"
  exit 0
fi

# Check that credential helpers point to existing executables.
while IFS= read -r line; do
  cmd=$(printf '%s' "$line" | sed -E 's/.*=[[:space:]]*!//' | awk '{print $1}')
  [[ -z "$cmd" ]] && continue
  case "$cmd" in
    /*) [[ -x "$cmd" ]] || { add "$(finding medium "credential.helper points to missing executable: $cmd")"; status="warn"; } ;;
    *)  command -v "$cmd" >/dev/null 2>&1 || { add "$(finding medium "credential.helper command not on PATH: $cmd")"; status="warn"; } ;;
  esac
done < <(grep -E '^[[:space:]]*helper[[:space:]]*=[[:space:]]*!' "$GITCFG" || true)

# Check user.email is set.
if ! grep -qE '^[[:space:]]*email[[:space:]]*=' "$GITCFG"; then
  add "$(finding low "user.email not set in config/git/config")"
  [[ "$status" == "ok" ]] && status="warn"
fi

emit_result "07-git-config" "Git config" "$status" "${findings:-[]}"
