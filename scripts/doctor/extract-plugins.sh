#!/usr/bin/env bash
# Extract all configured plugins from this dotfiles repo.
# Output: JSON array of {tool, repo} objects on stdout.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ROOT=$(dotfiles_root)

extract() {
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

extract | sort -u | jq -R 'split("\t") | {tool: .[0], repo: .[1]}' | jq -sc '.'
