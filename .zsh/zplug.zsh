ZPLUG_PROTOCOL=ssh

zplug "zplug/zplug", hook-build:'zplug --self-manage'

zplug "$DOTFILES/.zsh", from:local, use:"_*.zsh"

zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "b4b4r07/zsh-vimode-visual", use:"*.zsh", defer:3

zplug "$DOTFILES/.zsh/themes", from:local, as:theme

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:"fzf", frozen:1
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

zplug "peco/peco", as:command, from:gh-r, frozen:1
