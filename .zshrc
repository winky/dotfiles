DOTFILES=$HOME/.dotfiles
bindkey -d
#------------------------------------------------------
# Instal and load Plugin
#------------------------------------------------------
ZPLUG_HOME=$DOTFILES/.zplug
if [[ -f $ZPLUG_HOME/init.zsh ]]; then
  export ZPLUG_LOADFILE=$DOTFILES/.zsh/zplug.zsh

  source $ZPLUG_HOME/init.zsh
fi

if [[ -f ${HOME}/.iterm2_shell_integration.zsh ]]; then
  source ${HOME}/.iterm2_shell_integration.zsh
fi

export PATH="/usr/local/bin/jenv:$PATH"
eval "$(jenv init -)"
