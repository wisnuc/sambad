# for Samba docker for appifi/fruitmix

### Prerequisite
  1. [**Docker Usage Reference**](https://github.com/JiangWeiGitHub/Docker)
  2. Using ubuntu:16.04 as base container

### Notice
  1. Expose related ports<p>
  [*Reference*](https://www.samba.org/~tpot/articles/firewall.html)<p>
  
  ```
    udp 137
    udp 138
    tcp 139
    tcp 445
  ```
  2. Command Format<p>
  [*Reference*](https://github.com/docker/docker/issues/7459)<p>

  ```
  1) Run docker daemon
    docker daemon -H tcp://0.0.0.0:5678
  
  2) Run Samba Docker (SystemV Mode)
    docker run -p 137:137/udp -p 138:138/udp -p 139:139 -p 445:445 -ti -v /home/wisnuc/docker/smb.conf:/etc/samba/smb.conf -v /home/wisnuc/docker/bootstrap.sh:/bootstrap.sh IMAGEID

  3) Check Samba Container ID
    docker -H tcp://0.0.0.0:5678 ps -a

  4) Reenter into Samba Containter
    docker -H tcp://0.0.0.0:5678 exec -it IMAGEID bash
  ```

  3. Test Log Module<p>

  ```
  1) Add vfs object (full_audit) into smb.conf
    [user]
            # This share requires authentication to access
            path = /srv/samba/user/
            read only = no
            guest ok = no
            vfs objects = full_audit
            full_audit:prefix = %u|%I
            full_audit:success = open opendir
            full_audit:failure = all !open
            full_audit:facility = LOCAL7
            full_audit:priority = ALERT

  2) Add eth0's IP address (the running docker's container) into rsyslog.conf
    *.* @172.17.0.1:5555
    
  3) Restart samba & rsyslog service
    service nmbd restart
    service smbd restart
    service rsyslog restart
  
  4) Run nc to monitor log infor
    nc -l -u 172.17.0.1 -p 5555
  ```
