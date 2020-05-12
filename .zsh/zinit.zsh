zinit ice multisrc'_*.zsh'
zinit light "$DOTFILES/.zsh"

zinit ice lucid wait'!0' blockf atpull'zinit creinstall -q .'
zinit light 'zsh-users/zsh-completions'
zinit ice lucid wait'!0'
zinit light 'zsh-users/zsh-autosuggestions'
zinit ice lucid wait'!0'
zinit light 'zsh-users/zsh-syntax-highlighting'
zinit ice lucid wait'!0'
zinit light 'zsh-users/zsh-history-substring-search'

zinit ice lucid wait'!0' pick'init.sh'
zinit light 'b4b4r07/enhancd'
ENHANCD_FILTER=peco:fzf:fzy
export ENHANCD_FILTER

zinit ice lucid wait'!0' proto'ssh' from'gh-r' as'program' mv'hub* -> hub' \
  atclone'prefix=$ZPFX ./hub/install; ln -sf ./hub/etc/hub.zsh_completion _hub;' \
  atpull'%atclone' pick'$ZPFX/bin/hub*'
zinit light 'github/hub'

zinit ice lucid wait'!0' proto'ssh' from'gh-r' as'program'
zinit light https://github.com/junegunn/fzf-bin
zinit ice lucid wait'!0' as'command' multisrc'shell/{completion,key-bindings}.zsh' pick'bin/fzf-tmux'
zinit light 'junegunn/fzf'

zinit ice lucid wait'!0' proto'ssh' from'gh-r' as'program' mv'peco*/peco -> peco'
zinit light 'peco/peco'

# snippet for prompt theme
# Load OMZ Git library
zinit snippet OMZL::git.zsh
# Load Git plugin from OMZ
zinit snippet OMZP::git
zinit cdclear -q # <- forget completions provided up to this moment

setopt promptsubst
autoload -Uz colors && colors

zinit ice pic"*.zsh-theme"
zinit light "$DOTFILES/.zsh/themes"
