#!/bin/bash

set -e                              # should exit if any statement returns a non-true return value
set -o nounset                      # Treat unset variables as an error
SHELL="/home/test.sh"

source $SHELL
if [ $? -eq 0 ];then
    ionice -c 3 nmbd -D && ionice -c 3 smbd -D
    while true; do sleep 1000; done
else
    exit 100
fi
