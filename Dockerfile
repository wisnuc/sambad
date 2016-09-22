FROM ubuntu:16.04

MAINTAINER JiangWeiGitHub <wei.jiang@winsuntech.cn>

# Update apt sourcelist
RUN echo "deb http://ubuntu.uestc.edu.cn/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list \
 && echo "deb http://ubuntu.uestc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb http://ubuntu.uestc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb http://ubuntu.uestc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb http://ubuntu.uestc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list

# update apt
RUN apt-get update

# install net-tools samba with apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl net-tools samba && \
    service nmbd stop && service smbd stop && \
    rm -f /etc/samba/smb.conf

# install rsyslog with apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install rsyslog && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY samba.sh /usr/bin/

RUN chmod a+x /usr/bin/samba.sh

# backup system user infor & samba infor
RUN mkdir -p /wisnuc/config/backup/etc/samba && \
    mkdir -p /wisnuc/config/backup/var/lib/samba && \
    cp -f /etc/passwd /etc/shadow /etc/group /etc/gshadow /wisnuc/config/backup/etc/ && \
    cp -rf /etc/samba/* /wisnuc/config/backup/etc/samba/ && \
    cp -rf /var/lib/samba/* /wisnuc/config/backup/var/lib/samba/

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["samba.sh"]
