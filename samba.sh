#!/bin/bash

set -e                              # should exit if any statement returns a non-true return value

chmod a+x /bootstrap.sh
/bootstrap.sh

service rsyslog restart
ionice -c 3 nmbd -D && ionice -c 3 smbd -D

while true; do sleep 1000; done
