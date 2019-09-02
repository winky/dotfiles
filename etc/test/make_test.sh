#!/bin/bash

trap 'echo Error: $0; exit 1' ERR INT

ERR=0

deploy() {
  cd $DOTPATH
  make deploy >/dev/null
  if [ $? -eq 0 ]; then
    echo "Success: Deploy dotfiles"
  else
    echo "Fail: Deploy dotfiles"
    echo "$0: $LINENO: $FUNCNAME"
  fi
}

link() {
  cd $DOTPATH
  for i in $(make -s list | sed "s/[*@/]$//g"); do
    if [ ! -L $HOME/$i ]; then
      echo "Fail: Not found $i"
      ERR=1
    elif [ "$(readlink $HOME/$i)" != $DOTPATH/$i ]; then
      echo "Fail: get link of $i"
      ERR=1
    fi
  done

  if [ "$ERR" = 0 ]; then
    echo "Success: Check the file link"
  else
    echo "Fail: Check the file link"
  fi
}

deploy
link