#!/bin/bash

set -e                              # should exit if any statement returns a non-true return value

sleep 5

# get hot ip address on docker0 bridge
gateway=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{ print $2 }')

echo -n "@@@@ $(date) sambad start" > /dev/udp/${gateway}/3721 

# update rsyslog conf
echo "local7.* @${gateway}:3721" >> /etc/rsyslog.conf
service rsyslog restart

ro=`curl ${gateway}:3721/samba/rollover`
echo -n "@@@@ $(date) init rollover ${ro}" > /dev/udp/${gateway}/3721

# write smb.conf
curl ${gateway}:3721/samba/conf > /etc/samba/smb.conf

# get createUsers script
curl ${gateway}:3721/samba/createUsers > /createUsers.sh
chmod a+x /createUsers.sh
/createUsers.sh

# get samba user database in list format
curl ${gateway}:3721/samba/database > /database
pdbedit -i smbpasswd:/database

ionice -c 3 nmbd -D && ionice -c 3 smbd -D

while true; do
  sleep 5
  rollover=`curl ${gateway}:3721/samba/rollover`
  if [ "$ro" != "$rollover" ]; then
    echo -n "@@@@ $(date) init rollover ${ro}, new rollover ${rollover}, see you later!" > /dev/udp/${gateway}/3721
    exit 0
  fi
done
