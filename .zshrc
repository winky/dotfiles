DOTFILES=$HOME/dotfiles
bindkey -d
#------------------------------------------------------
# Instal and load Plugin
#------------------------------------------------------
ZPLUG_HOME=$DOTFILES/.zplug
if [[ -f $ZPLUG_HOME/init.zsh ]]; then
  export ZPLUG_LOADFILE=$DOTFILES/.zsh/zplug.zsh

  source $ZPLUG_HOME/init.zsh

  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
    echo
  fi
  zplug load
fi

if [[ -f ${HOME}/.iterm2_shell_integration.zsh ]]; then
    source ${HOME}/.iterm2_shell_integration.zsh
fi
