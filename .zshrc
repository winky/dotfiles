# Environmental variables
# Langage setting
export LANG=ja_JP.UTF-8
# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dpoggi"
plugins=(git)

source $ZSH/oh-my-zsh.sh
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Setting alias
alias vi='/usr/local/bin/vim'
alias la='ls -a'
alias ll='ls -l'
alias rmf='rm -rf'

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit

# cd後、自動的にls
setopt auto_cd
function chpwd() { ls }
