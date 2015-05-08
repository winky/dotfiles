# Environmental variables
# Langage setting
export LANG=ja_JP.UTF-8
# Path to your oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dpoggi_my"
plugins=(git)

source $ZSH/oh-my-zsh.sh
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin"

# Setting alias
alias vi='vim'
alias cdh='dirs -v'
alias pd='popd'
alias la='ls -a'
alias ll='ls -hl'
alias al='ls -hal'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias his='history'
alias rmf='rm -rf'
alias vagini='vagrant init chef-CentOS6.5'
alias vagu='vagrant up'
alias vagh='vagrant halt'
alias ng='ngix'
alias gti='git'
fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# cd後、自動的にls
setopt auto_cd
function chpwd() { ls }
