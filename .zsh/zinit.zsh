zinit ice multisrc'_*.zsh'
zinit light "$DOTFILES/.zsh"

zinit lucid wait'!0' for \
  light-mode 'zsh-users/zsh-autosuggestions' \
  light-mode 'zsh-users/zsh-syntax-highlighting' \
  light-mode 'zsh-users/zsh-history-substring-search' \

zinit ice lucid wait'!0' pick'init.sh' \
  atclone'rm -rf conf.d; rm -rf functions; rm -f *.fish;' \
  atload'ENHANCD_FILTER=peco:fzf:fzy; export ENHANCD_FILTER;'
zinit light 'b4b4r07/enhancd'

zinit ice lucid wait'!0' proto'ssh' from'gh-r' as'program'
zinit light 'junegunn/fzf-bin'

zinit ice lucid wait'!0' as'command' multisrc'shell/{completion,key-bindings}.zsh' pick'bin/fzf-tmux'
zinit light 'junegunn/fzf'

zinit ice lucid wait'!0' proto'ssh' from'gh-r' as'program' mv'peco*/peco -> peco'
zinit light 'peco/peco'

zinit ice lucid wait'!0' form'gh-r' as'program' pick'asdf.sh'
zinit light 'asdf-vm/asdf'

zinit ice lucid wait'!0' proto'ssh' from'gh-r' as'program' mv'gh*/bin/gh -> gh'
zinit light 'cli/cli'

# snippet for prompt theme
# Load OMZ Git library
zinit snippet OMZL::git.zsh

setopt promptsubst
autoload -Uz colors && colors

zinit ice pic"*.zsh-theme"
zinit light "$DOTFILES/.zsh/themes"

zinit ice lucid wait'!0' blockf atpull'zinit creinstall -q .' atload'zicompinit; zicdreplay'
zinit light 'zsh-users/zsh-completions'
