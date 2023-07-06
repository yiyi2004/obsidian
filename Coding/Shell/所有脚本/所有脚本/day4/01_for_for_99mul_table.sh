#!/bin/bash
# 功能: 九九乘法表
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制外层循环
for num1 in {1..9}
do
   # 内层循环定制
   for num2 in $(seq $num1)
   do 
      echo -e "\e[$[$RANDOM%3+31]m${num1}x${num2}=$[num1*num2]\e[0m\t\c"
   done
   # 每层循环之后换行
   echo
done

