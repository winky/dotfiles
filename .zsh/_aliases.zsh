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
alias his='history'

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

alias gr='git rebase -i'

alias gsb='git status -ab'
alias gst='git status'
alias gsh='git stash'
alias gshp='git stash pop'

alias gsbu='git submodule update'

alias gl='git log'
alias glg='git log --graph --branches --pretty=format:"%C(yellow)%h%C(cyan)%d%Creset %s %C(green)- %an, %cr%Creset"'
alias gll='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
galias() { alias | grep 'git' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

alias dk='docker'
alias dki='docker images'
alias dkp='docker ps'
alias dkpa='docker ps -a'
alias dkr='docker run'
alias dkrd='docker run -d -P'
alias dkri='docker run -i -t'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkrmf='(){ docker stop $1 && docker rm $1 }'
alias dklogin='(){ docker exec -it $(docker ps -aqf "name=$1") bash; }'
dkalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

alias py='python'

alias -g G='| grep'

alias -g L='2>&1 | tee'

if type "pyton2"  > /dev/null 2>&1; then
    alias python='python2'
fi

if type "pip2"  > /dev/null 2>&1; then
    alias pip='pip2'
fi
