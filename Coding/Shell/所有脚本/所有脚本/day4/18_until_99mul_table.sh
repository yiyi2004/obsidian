#!/bin/bash
# 功能: until语句99乘法表实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 外层循环
num1=9
until [ ${num1} -eq 0 ]
do
  # 内层循环
  num2=1
  until [ ${num2} -gt ${num1} ]
  do
     echo -e "\e[$[$RANDOM%5+31]m${num1}x${num2}=$[${num1}*${num2}]\e[0m\t\c"
     num2=$[$num2+1]
  done
  echo
  # 数据递减
  num1=$[$num1-1]
done
