#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

cat ${SCRIPT_DIR}/extensions | while read line
do
 code --install-extension $line
done

code --list-extensions > ${SCRIPT_DIR}/extensions
