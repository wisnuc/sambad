#!/bin/bash

set -e                              # should exit if any statement returns a non-true return value

sleep 5

# get hot ip address on docker0 bridge
gateway=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{ print $2 }')

echo -n "@@@@ $(date) sambad start" > /dev/udp/${gateway}/3721

# remove existing user with 5000 > uid >= 2000
while read line; do

  USERNAME=$(echo "$line" | cut -f 1 -d:)
  USERUID=$(echo "$line" | cut -f 3 -d:)

  if [ "$USERUID" -ge "2000" ] && [ "$USERUID" -lt "5000" ]; then
    deluser $USERNAME
    echo -n "@@@@ $(date) user $USERNAME deleted" > /dev/udp/${gateway}/3721
  fi  

done < /etc/passwd

# remove existing tdb
rm -rf /var/lib/samba/private/passdb.tdb
echo -n "@@@@ $(date) samba passdb.tdb removed" > /dev/udp/${gateway}/3721

# remove existing username map
rm -rf /usernamemap.txt

# update rsyslog conf
rm -rf /etc/rsyslog.conf
cp /etc/rsyslog.conf.orig /etc/rsyslog.conf
echo "local7.* @${gateway}:3721" >> /etc/rsyslog.conf
service rsyslog restart

ro=`curl ${gateway}:3721/samba/rollover`
echo -n "@@@@ $(date) init rollover ${ro}" > /dev/udp/${gateway}/3721

# write username map
curl ${gateway}:3721/samba/usernamemap > /usernamemap.txt
echo -n "@@@@ $(date) usernamemap.txt written"

# write smb.conf
curl ${gateway}:3721/samba/conf > /etc/samba/smb.conf
echo -n "@@@@ $(date) smb.conf written" > /dev/udp/${gateway}/3721

# get createUsers script
curl ${gateway}:3721/samba/createUsers > /createUsers.sh
chmod a+x /createUsers.sh
/createUsers.sh
echo -n "@@@@ $(date) users created" > /dev/udp/${gateway}/3721

# get samba user database in list format
curl ${gateway}:3721/samba/database > /database
pdbedit -i smbpasswd:/database
echo -n "@@@@ $(date) samba passwd database updated" > /dev/udp/${gateway}/3721

ionice -c 3 nmbd -D && ionice -c 3 smbd -D
echo -n "@@@@ $(date) smbd and nmbd started" > /dev/udp/${gateway}/3721

while true; do
  sleep 5
  rollover=`curl ${gateway}:3721/samba/rollover`
  if [ "$ro" != "$rollover" ]; then
    echo -n "@@@@ $(date) init rollover ${ro}, new rollover ${rollover}, see you later!" > /dev/udp/${gateway}/3721
    exit 0
  fi
done
