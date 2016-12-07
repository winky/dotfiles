# Environmental variables
# Langage setting
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
# Langage setting for ssh
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# Path to your oh-my-zsh configuration
ZSH=$HOME/oh-my-zsh
ZSH_THEME="dpoggi_my"
plugins=(git)

# Path to nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

source $ZSH/oh-my-zsh.sh
source $HOME/.iterm2_shell_integration.zsh
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/texbin"

# Setting alias
alias vi='vim'
alias cdh='dirs -v'
alias pd='popd'
alias la='ls -a'
alias ll='ls -hl'
alias lla='ls -hal'
alias mkdir='mkdir -p'
#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'
alias his='history'
alias rmf='rm -rf'
alias vagini='vagrant init chef-CentOS6.5'
alias vagu='vagrant up'
alias vagh='vagrant halt'
alias ng='ngix'
alias gti='git'
alias tmx='tmux'
alias tmxa='tmux attach-session -t'
#fpath=(/usr/local/share/zsh-completions $fpath)
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u
__git_files() { _files }

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# cd後、自動的にls
setopt auto_cd
# 移動したディレクトリを記録しておく。"cd -[Tab]"で移動履歴を一覧
setopt auto_pushd
function chpwd() { ls }
# コマンド訂正
setopt correct
