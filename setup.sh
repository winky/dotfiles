#!/bin/bash

DOT_FILES=(.zshrc .vimrc .vim .tmux.conf oh-my-zsh .iterm2_shell_integration.zsh)

for file in ${DOT_FILES[@]}
do
  if [ ! -e $HOME/$file ]; then
    ln -s $HOME/dotfiles/$file $HOME/$file
  fi
done

if [ ! -e $HOME/oh-my-zsh/themes/dpoggi_my.zsh-theme ]; then
  ln -s $HOME/dotfiles/dpoggi_my.zsh-theme $HOME/oh-my-zsh/themes/dpoggi_my.zsh-theme
fi
