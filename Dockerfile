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

# install samba with apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    samba && \
    rm -f /etc/samba/smb.conf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# install rsyslog with apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    samba && \
    rm -f /etc/rsyslog.conf

# Caution samba.sh permission, chmod 777
COPY samba.sh /usr/bin/

RUN chmod a+x /usr/bin/samba.sh

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["samba.sh"]
