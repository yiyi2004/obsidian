# syntax=docker/dockerfile:1.4
FROM ubuntu:20.04

ARG version=1

EXPOSE 80 443
WORKDIR /root/workplace

# ENV transport parameters by ENV

RUN <<-EOF
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	apt-get -y update
EOF

# ADD . /root/

# RUN Command
