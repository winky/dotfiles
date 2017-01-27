#!/bin/bash

DOT_FILES=(.bashrc .zshrc .vimrc .vim .tmux.conf .iterm2_shell_integration.zsh .editorconfig)

for file in ${DOT_FILES[@]}
do
  if [ ! -e $HOME/$file ]; then
    ln -s $HOME/dotfiles/$file $HOME/$file
  fi
done
