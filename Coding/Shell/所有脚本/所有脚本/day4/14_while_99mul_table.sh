#!/bin/bash
# 功能: while语句99乘法表实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 外层循环
num1=1
while [ ${num1} -le 9 ]
do
  # 内层循环
  num2=1
  while [ ${num2} -le ${num1} ]
  do  
     # 信息输出
     echo -e "\e[$[$RANDOM%5+31]m${num1}x${num2}=$[${num1}*${num2}]\e[0m\t\c"
     # num2递增
     let num2+=1
  done
  echo
  # num1递增
  let num1+=1
done
