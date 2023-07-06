#!/bin/bash
# 功能: until语句实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
num1=1
read -p "请输入退出的数据值: " max
# until的基本语法
until  [ ${num1} -gt ${max} ]
do
  echo "${num1}"
  let num1+=1
done
