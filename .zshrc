# Define variables
DOTFILES=$PWD
ZINIT_HOME=$DOTFILES/.zinit
ZINIT_ZSH=$ZINIT_HOME/bin/zinit.zsh
# Reset key bind
bindkey -d
#------------------------------------------------------
# Instal and load Plugin
# ZINIT https://github.com/zdharma/zinit
#------------------------------------------------------

if [[ -f $ZINIT_ZSH ]]; then
  declare -A ZINIT
  # Settings Customize Paths
  ZINIT[HOME_DIR]=$ZINIT_HOME
  ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump
  export ZPFX="$ZINIT[HOME_DIR]/polaris"

  # Load Zinit sourcee zsh
  source $ZINIT_ZSH

  # Load Zinit settings
  source $DOTFILES/.zsh/zinit.zsh
fi
