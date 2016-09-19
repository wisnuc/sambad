#!/bin/bash

set -e                              # should exit if any statement returns a non-true return value

chmod a+x /bootstrap.sh
/bootstrap.sh

echo "*.* @$(netstat -nr | grep '^0\.0\.0\.0' | awk '{ print $2 }'):5555" >> /etc/rsyslog.conf
service rsyslog restart
ionice -c 3 nmbd -D && ionice -c 3 smbd -D

while true; do sleep 1000; done
