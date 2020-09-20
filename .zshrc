DOTFILES=$PWD
ZINIT_HOME=$DOTFILES/.zinit
bindkey -d
#------------------------------------------------------
# Instal and load Plugin
# ZINIT https://github.com/zdharma/zinit
#------------------------------------------------------

if [[ -f $ZINIT_HOME/bin/zinit.zsh ]]; then
  declare -A ZINIT
  ZINIT[HOME_DIR]=$ZINIT_HOME
  ZINIT[BIN_DIR]=$ZINIT[HOME_DIR]/bin
  ZINIT[PLUGINS_DIR]=$ZINIT[HOME_DIR]/plugins
  ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump
  # Settings Customize Paths
  export ZPFX="$ZINIT[HOME_DIR]/polaris"

  source $ZINIT[BIN_DIR]/zinit.zsh

  source $DOTFILES/.zsh/zinit.zsh
fi
