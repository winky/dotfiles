#!/bin/bash

trap 'echo Error: $0; exit 1' ERR INT

ERR=0

for i in "$DOTPATH"/etc/test/*_test.sh
do
  bash "$i" || ERR=1
done