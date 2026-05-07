# Keybinds

# ghq + fzf: jump to a repository (Ctrl+])
function fzf-src() {
  local selected
  selected=$(ghq list -p | fzf --query "$LBUFFER" \
    --preview 'git -C {} log --oneline --decorate --color=always -20 2>/dev/null' \
    --preview-window=right:50%)
  if [ -n "$selected" ]; then
    BUFFER="cd $selected"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-src
bindkey '^]' fzf-src
