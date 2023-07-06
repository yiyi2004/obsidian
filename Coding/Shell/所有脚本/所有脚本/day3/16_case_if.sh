#!/bin/bash
# 功能: case嵌套if语句案例
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 接收用户信息
read -p "请确认是否携带违禁物品: " check_status

# 违禁物品安检
case "${check_status}" in
  "true")
     echo "禁止入站，携带危险物品";;
  "false")
     echo "开始检测车票是否过期"
     read -p "请确认车票是否过期: " ticket_check
     if [ "${ticket_check}" == "true" ]
     then
        echo "车票过期，禁止登车"
     else
        echo "车票未过期，允许登车"
     fi;;
  *)
     echo "再检查一遍";;
esac
