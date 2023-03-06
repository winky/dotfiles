zinit ice multisrc'_*.zsh'
zinit light "$DOTFILES/.zsh"

zinit lucid wait'!0' light-mode for \
  'zsh-users/zsh-autosuggestions' \
  'zsh-users/zsh-syntax-highlighting' \
  'zsh-users/zsh-history-substring-search' \

zinit ice lucid wait'!0' pick'init.sh' \
  atload'ENHANCD_FILTER=peco:fzf:fzy; export ENHANCD_FILTER;'
zinit light 'b4b4r07/enhancd'

zinit ice lucid wait'!0' as'program' pick'bin/fzf' \
  atclone'./install --xdg --no-update-rc --completion --key-bindings' \
  atpull'%atclone' multisrc'shell/{key-bindings,completion}.zsh'
zinit light 'junegunn/fzf'

zinit ice lucid wait'!0' from'gh-r' as'program' bpick'*linux_arm64*' light-mode for \
  mv'peco*/peco -> peco' 'peco/peco' \
  mv'gh*/bin/gh -> gh' 'cli/cli' \

zinit lucid wait'!0' as'program' light-mode for \
  atload'. ./asdf.sh; ASDF_DIR=$DOTFILES/.zinit/plugins/asdf-vm---asdf; ASDF_DATA_DIR=$DOTFILES/.zinit/plugins/asdf-vm---asdf;' \
  pick'bin/asdf' '@asdf-vm/asdf'

# snippet for prompt theme
# Load OMZ Git library
zinit snippet OMZL::git.zsh

zinit ice pic"*.zsh-theme"
zinit light "$DOTFILES/.zsh/themes"

zinit ice lucid wait'!0' blockf atpull'zinit creinstall -q .' atload'zicompinit; zicdreplay'
zinit light 'zsh-users/zsh-completions'
