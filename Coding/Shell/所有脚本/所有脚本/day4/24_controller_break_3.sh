#!/bin/bash
# 功能: break语句实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 外层遍历数字循环
for num in {1..5}
do
   # 内层遍历字符
   for str in {a..g}
   do
      if [ ${num} -eq 2 -a "${str}" == "d" ] 
      then
          break 2
      else
         echo "${num} -- ${str}"
      fi
   done
done
