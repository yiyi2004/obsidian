```dockerfile
FROM ubuntu:20.04
ENV GOROOT /usr/local/go
ENV GOPATH /home/data/gopath
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct
ENV GOBIN=/bin

RUN sed -i 's#http://archive.ubuntu.com/#http://mirrors.tuna.tsinghua.edu.cn/#' /etc/apt/sources.list
RUN apt-get update && apt-get -y install curl
RUN curl -s -o go.tar.gz https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
RUN tar --remove-files -C /usr/local/ -zxf go.tar.gz
RUN mkdir -p /home/data/go
RUN ln -sv /usr/local/go/bin/go /bin
# ADD src/ /home/data/gopath/src
# ADD pkg/ /home/data/gopath/pkg
WORKDIR /home/data/gopath
```