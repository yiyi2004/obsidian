# Answer
```shell
FROM node:16 AS node-builder

LABEL maintainer="mingcheng<mc@sf.com>"

COPY . /answer
WORKDIR /answer
RUN make install-ui-packages ui && mv ui/build /tmp

FROM golang:1.18 AS golang-builder
LABEL maintainer="aichy"

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PACKAGE github.com/answerdev/answer
ENV GOPROXY https://goproxy.cn,direct
ENV BUILD_DIR ${GOPATH}/src/${PACKAGE}
# Build
COPY . ${BUILD_DIR}
WORKDIR ${BUILD_DIR}
COPY --from=node-builder /tmp/build ${BUILD_DIR}/ui/build
RUN make clean build && \
	cp answer /usr/bin/answer && \
    mkdir -p /data/upfiles && chmod 777 /data/upfiles && \
    mkdir -p /data/i18n && chmod 777 /data/i18n && cp -r i18n/*.yaml /data/i18n

FROM debian:bullseye
ENV TZ "Asia/Shanghai"
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
        && sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
        && echo "Asia/Shanghai" > /etc/timezone \
        && apt -y update \
        && apt -y upgrade \
        && apt -y install ca-certificates openssl tzdata curl netcat dumb-init \
        && apt -y autoremove \
        && mkdir -p /tmp/cache

COPY --from=golang-builder /data /data
VOLUME /data

COPY --from=golang-builder /usr/bin/answer /usr/bin/answer
COPY /script/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
```

```yaml
version: "3.9"
services:
  answer:
    image: answerdev/answer:latest
    ports:
      - '9080:80'
    restart: on-failure
    depends_on:
      db:
        condition: service_healthy
    links:
      - db
    volumes:
      - ./answer-data/data:/data
  db:
    image: mariadb:10.4.7
    ports:
      - '13306:3306'
    restart: on-failure
    environment:
      MYSQL_DATABASE: answer
      MYSQL_ROOT_PASSWORD: root
    healthcheck:
      test: [ "CMD", "mysqladmin" ,"ping", "-uroot", "-proot"]
      timeout: 20s
      retries: 10
    command: ['mysqld', '--character-set-server=utf8mb4', '--collation-server=utf8mb4_unicode_ci', '--skip-character-set-client-handshake']
    volumes:
      - ./answer-data/mysql:/var/lib/mysql
```

- [answer/Dockerfile at main · answerdev/answer (github.com)](https://github.com/answerdev/answer/blob/main/Dockerfile)

# html
```dockerfile
FROM nginx:1.19.0-alpine

LABEL maintainer="mritd <mritd@linux.com>"

ARG TZ='Asia/Shanghai'
ENV TZ ${TZ}

RUN apk upgrade --update \
    && apk add bash tzdata curl wget ca-certificates \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && rm -rf /usr/share/nginx/html /var/cache/apk/*

COPY landscape-animation-experiment /usr/share/nginx/html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

```
- 上面包含配置系统时区的方式

# apt-cacher-ng
- 缓存服务器
- 你可以将自己的 dockerfile 封装成一个仓库。

通过例子去学习是一个不错的方法，但是目前做的比较少。你可以做一下。



# Reference
- [Dockerfile Project (github.com)](https://github.com/dockerfile)
- [docker/awesome-compose: Awesome Docker Compose samples (github.com)](https://github.com/docker/awesome-compose)
- [jessfraz/dockerfiles: Various Dockerfiles I use on the desktop and on servers. (github.com)](https://github.com/jessfraz/dockerfiles)
- [mritd/dockerfile: some personally made dockerfile (github.com)](https://github.com/mritd/dockerfile)
- 上面两个库是重要的学习资料
