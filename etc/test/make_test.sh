#!/bin/bash

trap 'echo Error: $0; exit 1' ERR INT

ERR=0

deploy() {
  cd "$DOTPATH"
  make deploy >/dev/null
  if [ $? -eq 0 ]; then
    echo "Success dotfiles deploy"
  else
    echo "Fail dotfiles deploy"
    echo "$0: $LINENO: $FUNCNAME"
  fi
}

deploy