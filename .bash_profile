# Source global definitions
if [ -f ~/dotfiles/.bashrc ]; then
	. ~/dotfiles/.bashrc
fi

# delete until slash
stty werase undef
bind '"\C-w": unix-filename-rubout'

# User specific aliases and functions
set -o ignoreeof

# colorful primary prompt string
git_branch() {
  echo $(git branch --no-color 2>/dev/null | sed -ne "s/^\* \(.*\)$/\1/p")
}
PS1='\n\[\033[0;32m\]\u\[\033[0m\]@\[\033[0;36m\]\H\n\[\033[0;35m\]\w/ \[\033[0m\]<= \[\033[0;33m\]$(git_branch)\n\[\033[0;31m\]$\[\033[0m\] '
MYSQL_PS1='\U> '

export LESS='-R'
export LESSOPEN=' | /usr/local/share/source-highlight/src-hilite-lesspipe.sh %s'

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias ll='ls -hl '
alias la='ls -a '
alias al='ls -hal '
alias lm='ls -hal  | more'
alias his='history'
alias preview='open -a Preview'
alias top='htop'
alias grep='egrep -n --color=always'
alias tree='tree -a'
alias shrst='exec $SHELL -l'
alias gip='curl http://ipcheck.ieserver.net'
alias vg='vagrant'
alias ng='nginx'
alias fxg='find ./ | xargs grep -n --color=always '
alias gti='git'

# composer
export PATH="$HOME/.composer/vendor/bin:$PATH"
