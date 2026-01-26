# Environmental variables
# Language setting
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8
# Language setting for ssh
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History
# History file
export HISTFILE=$HOME/.zsh_history
# History size in memory
export HISTSIZE=100000
# The number of history entries to save
export SAVEHIST=100000

# ls command colors
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# PATH configuration
# Add Homebrew paths (for both Intel and Apple Silicon Macs)
[[ -d /opt/homebrew/bin ]] && export PATH="/opt/homebrew/bin:$PATH"
[[ -d /usr/local/bin ]] && export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
