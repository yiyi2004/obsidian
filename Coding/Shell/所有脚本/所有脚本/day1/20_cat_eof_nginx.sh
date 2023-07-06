#!/bin/bash
# 功能：使用 eof 在定制nginx环境的时候，自动配置文件

# 定制配置相关的普通变量
NGINX_DIR='/data/server/conf'
NGINX_FILE='nginx.conf'

# 创建基本目录
mkdir -p ${NGINX_DIR} -p

# 手工定制nginx配置文件
cat > ${NGINX_DIR}/${NGINX_FILE} <<- EOF
server {
  listen 80;
  server_name www.superopsmsb.com;
  location / {
    proxy_pass http://10.0.0.18:10086;
  }
}
EOF
