#!/usr/bin/env bash
# Check plugin repos for archive status and staleness via gh api.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib.sh"

ROOT=$(dotfiles_root)

if ! command -v gh >/dev/null 2>&1; then
  emit_result "05-plugins-status" "Plugin freshness" "warn" \
    "$(finding low "gh not found, skipping plugin status check")"
  exit 0
fi

# Collect plugin repos from all known sources.
extract_plugins() {
  # zsh / zinit
  if [[ -f "$ROOT/.zsh/zinit.zsh" ]]; then
    grep -hEo "zinit (light|load) ['\"][a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+['\"]" "$ROOT/.zsh/zinit.zsh" \
      | sed -E "s/.*['\"]([^'\"]+)['\"]/zsh\t\1/" || true
  fi

  # tmux / tpm
  if [[ -f "$ROOT/.tmux.conf" ]]; then
    grep -hEo "@plugin ['\"][a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+['\"]" "$ROOT/.tmux.conf" \
      | sed -E "s/.*['\"]([^'\"]+)['\"]/tmux\t\1/" \
      | awk -F'\t' '{
          split($2, a, "/")
          # tmux-plugins/X without tmux- prefix actually means tmux-plugins/tmux-X
          if (a[1] == "tmux-plugins" && a[2] !~ /^tmux-/) {
            print $1 "\t" a[1] "/tmux-" a[2]
          } else { print $0 }
        }' || true
  fi

  # neovim / lazy.nvim
  if [[ -d "$ROOT/config/nvim/lua/plugins" ]]; then
    while IFS= read -r line; do
      printf 'neovim\t%s\n' "$line"
    done < <(grep -rhEo '"[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+"' "$ROOT/config/nvim/lua/plugins" 2>/dev/null \
              | tr -d '"' | grep -E '^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$' | sort -u || true)
  fi

  # vim / dein
  if [[ -d "$ROOT/.vim/rc" ]]; then
    grep -hE "^repo[[:space:]]*=" "$ROOT/.vim/rc"/*.toml 2>/dev/null \
      | sed -E "s/^repo[[:space:]]*=[[:space:]]*['\"]([^'\"]+)['\"].*/vim\t\1/" || true
  fi
}

entries=()
while IFS= read -r line; do
  [[ -n "$line" ]] && entries+=("$line")
done < <(extract_plugins | sort -u)

findings=""
add() { findings="${findings:+$findings$'\n'}$1"; }
total=${#entries[@]}
archived=0
stale=0

# Threshold: 730 days since last push = "stale"
stale_seconds=$((730 * 86400))
now=$(date +%s)

for entry in "${entries[@]}"; do
  [[ -z "$entry" ]] && continue
  tool="${entry%%$'\t'*}"
  repo="${entry#*$'\t'}"

  # Skip if not user/repo shape
  [[ "$repo" == *"/"* ]] || continue

  json=$(gh api "repos/$repo" 2>/dev/null || true)
  if [[ -z "$json" ]]; then
    continue
  fi

  is_archived=$(printf '%s' "$json" | jq -r '.archived // false')
  pushed_at=$(printf '%s' "$json" | jq -r '.pushed_at // empty')

  if [[ "$is_archived" == "true" ]]; then
    add "$(finding high "Archived: $repo ($tool)" "Repository is archived; consider replacement.")"
    archived=$((archived + 1))
    continue
  fi

  if [[ -n "$pushed_at" ]]; then
    pushed_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$pushed_at" +%s 2>/dev/null \
                || date -d "$pushed_at" +%s 2>/dev/null || echo 0)
    if [[ "$pushed_epoch" -gt 0 ]]; then
      age=$((now - pushed_epoch))
      if [[ "$age" -gt "$stale_seconds" ]]; then
        days=$((age / 86400))
        add "$(finding medium "Stale: $repo ($tool)" "No pushes for ${days} days (since $pushed_at).")"
        stale=$((stale + 1))
      fi
    fi
  fi
done

if [[ "$archived" -gt 0 ]]; then
  status="fail"
elif [[ "$stale" -gt 0 ]]; then
  status="warn"
else
  status="ok"
fi

# Always include a summary finding for context
summary="$(finding low "Checked $total plugins" "archived=$archived stale=$stale (≥2y no push)")"
findings="${findings:+$findings$'\n'}$summary"

emit_result "05-plugins-status" "Plugin freshness" "$status" "$findings"
