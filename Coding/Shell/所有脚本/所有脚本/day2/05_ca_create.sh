#!/bin/bash
# 功能: ca证书的创建
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 1 创建CA目录
mkdir /tmp/CA
cd /tmp/CA

# 2 创建私钥
(umask 077; openssl genrsa -out ca.key 2048)

# 3 创建证书
openssl req -new -x509 -key ca.key -out ca.crt -days 365 -subj /C=CN/ST=BJ/L=BJ/O=msb/OU=msb/CN=www.superopsmsb.com
# 4 查看信息
openssl x509 -in ca.crt -noout -text > /tmp/ca.txt 2>&1 
grep 'Subject:' /tmp/ca.txt
