#!/bin/bash
# 功能: 模拟互联网用户访问web网站
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
file='ip.txt'
web_addr='10.0.0.12'

# 循环访问网站
while true
do
  # 读取ip地址
  cat ${file} | while read ip
  do
    for_num=$(echo ${ip} | cut -d "." -f4)
    # 循环ip访问
    for i in $(seq ${for_num})
    do
      # 模拟200的页面访问
      curl -I -s -H "X-Forwarded-For: ${ip}" ${web_addr} >> /dev/null 2>&1
      # 模拟404的页面访问
      curl -I -s -H "X-Forwarded-For: ${ip}" ${web_addr}/${for_num}/ >> /dev/null 2>&1
    done
    sleep 1
  done
done

