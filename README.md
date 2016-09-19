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
    docker run -p 137:137/udp -p 138:138/udp -p 139:139 -p 445:445 -ti -v /home/wisnuc/docker/smb.conf:/etc/samba/smb.conf -v /home/wisnuc/docker/rsyslog.conf:/etc/rsyslog.conf -v /home/wisnuc/docker/bootstrap.sh:/bootstrap.sh IMAGEID

  3) Check Samba Container ID
    docker -H tcp://0.0.0.0:5678 ps -a

  4) Reenter into Samba Containter
    docker -H tcp://0.0.0.0:5678 exec -it IMAGEID bash
  ```
