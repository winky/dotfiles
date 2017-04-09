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

alias history='history -E 1'

# For git
alias ga='git add'

alias gb='git branch'
alias gbd='git branch -d'

alias gc='git commit -v'
alias gcm='git commit -m'

alias gco='git checkout'
alias gcob='git checkout -b'

alias gd='git diff'

alias gm='git merge'
alias gmo='git merge origin'
alias gmom='git merge origin/master'
alias gmu='git merge upstream'
alias gmum='git merge upstream/master'

alias gpo='git push origin'
alias ggpo='git push origin $(git_current_branch)'

alias gpl='git pull'
alias ggplo='git pull origin $(git_current_branch)'
alias gplu='git pull upsteram'
alias gplum='git pull upstram master'

alias gsb='git status -ab'
alias gst='git status'

alias gsbu='git submodule update'

alias gl='git log'
alias glg='git log --graph --branches --pretty=format:"%C(yellow)%h%C(cyan)%d%Creset %s %C(green)- %an, %cr%Creset"'
alias gll='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
