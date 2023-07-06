#!/bin/bash
# 功能: continue语句实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 单层while死循环
while true
do
   read -p "请输入一个数字: " num
   case ${num} in
     1|2|3|4|5)
        echo "${num} !";;
     *)
        echo "请输入 1-5 之间的数据。"
        continue
        echo "${num}"
   esac
   echo "${num}-----------------"
done
