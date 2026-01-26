# Define variables
# Get dotfiles directory (works even with symlinks)
DOTFILES=${${(%):-%x}:A:h}
ZINIT_HOME=$DOTFILES/.zinit
ZINIT_ZSH=$ZINIT_HOME/bin/zinit.zsh

# Set XDG cache directory if not set
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

#------------------------------------------------------
# Install and load Plugin
# ZINIT https://github.com/zdharma/zinit
#------------------------------------------------------

if [[ -f $ZINIT_ZSH ]]; then
  declare -A ZINIT
  # Settings Customize Paths
  ZINIT[HOME_DIR]=$ZINIT_HOME
  ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump
  export ZPFX="${ZINIT[HOME_DIR]}/polaris"

  # Load Zinit source zsh
  source $ZINIT_ZSH

  # Load Zinit settings
  source $DOTFILES/.zsh/zinit.zsh
fi

#------------------------------------------------------
# Directory navigation: zoxide
#------------------------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
