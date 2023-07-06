#!/bin/bash
# 功能: exit语句实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 需求：两个变量，随意满足一个条件，就退出程序

# 外部循环
for num1 in {1..9}
do
   # 内部循环
   for string in {a..z}
   do
      # 双变量的判断
      if [ ${num1} == "7" -a ${string} == "e"  ]
      then
         echo "${num1}-${string}"
         exit 129
      else
         echo "${num1}  --- ${string}"
      fi
   done
done
