alias vi='vim'
alias cdh='dirs -v'
alias pd='popd'

# Mac と Linuxの差分のため
if [ $(uname) = "Darwin" ]; then
    alias ls='ls -G '
elif [ $(uname) = "Linux" ]; then
    alias ls='ls -F --color=always '
fi

alias la='ls -a'
alias ll='ls -hl'
alias lla='ls -hal'
alias mkdir='mkdir -p'
alias gti='git'
alias tmx='tmux'
alias tmxa='tmux attach-session -t'

# For git
alias ga='git add'

alias gb='git branch'
alias gbd='git branch -d'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcm='git commit -m'

alias gco='git checkout'

alias gd='git diff'

alias gm='git merge'
alias gmo='git merge origin/'
alias gmom='git merge origin/master'
alias gmu='git merge upstream/'
alias gmum='git merge upstream/master'

alias gpo='git push origin'
alias ggpo='git push origin $(git_current_branch)'

alias gl='git pull'
alias gglo='git pull origin $(git_current_branch)'
alias glu='git pull upsteram'
alias glum='git pull upstram master'

alias gsb='git status -ab'
alias gst='git status'

alias gsu='git submodule update'
