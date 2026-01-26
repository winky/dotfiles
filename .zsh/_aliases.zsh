alias vi='vim'
alias cdh='dirs -v'
alias pd='popd'

if command -v nvim > /dev/null 2>&1; then
    alias vim='nvim'
fi

# ls / eza configuration
if command -v eza >/dev/null 2>&1; then
    # Use eza if available
    alias ls='eza --icons --git'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lla='eza -la --icons --git'
    alias tree='eza --tree --icons'
else
    # Fallback to standard ls
    if [[ $(uname) == "Darwin" ]]; then
        alias ls='ls -G'
    elif [[ $(uname) == "Linux" ]]; then
        alias ls='ls -F --color=always'
    fi
    alias la='ls -a'
    alias ll='ls -hl'
    alias lla='ls -hal'
fi
alias mkdir='mkdir -p'
alias gti='git'
alias cl='clear'

alias tmx='tmux'
alias tmxa='tmux attach-session -t'

alias history='history -E 1'
alias his='history'

# For git
alias ga='git add'

alias gb='git branch'
alias gbd='git branch -d'
gbdf() { git branch --merged $1 | grep -vE "^\*|master|$1" | xargs -I % git branch -D % }

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
gpr() { git fetch origin pull/$1/head:pull_$1 && git checkout pull_$1 }
alias gpor='git push origin $(git_current_branch) && gh pr create -w'

alias gpl='git pull'
alias gplo='git pull origin'
alias ggplo='git pull origin $(git_current_branch)'
alias gplu='git pull upstream'
alias gplum='git pull upstream master'

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
alias dkrd='dkr -d -P'
alias dkri='dkr -i -t'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
dkrmf() { docker stop $1 && docker rm $1 }
dklogin() { docker exec -it $(docker ps -aqf "name=$1") bash; }
dkalias() { alias | grep 'docker' | grep -v 'docker-compose' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

alias dkc='docker-compose'
dkcalias() { alias | grep 'docker-compose' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

alias kube='kubectl'

alias vg='vagrant'
alias vgu='vagrant up'
alias vgd='vagrant destroy'
alias vgst='vagrant status'
alias vglogin='vagrant ssh'
valias() { alias | grep 'vagrant' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# cat / bat configuration
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

# grep / ripgrep configuration
if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
else
    alias grep='grep --color=auto'
fi

alias py='python'

alias -g G='| grep'

alias -g L='2>&1 | tee'

if command -v python2 > /dev/null 2>&1; then
    alias python='python2'
fi

if command -v pip2 > /dev/null 2>&1; then
    alias pip='pip2'
fi
