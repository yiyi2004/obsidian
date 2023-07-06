#!/bin/bash
# 功能: while语句简单实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 定制初始值变量
str_num=1

# while语句
read -p "请输入最大的数据值: " max
while [ ${str_num} -le ${max} ] 
do
   echo "${str_num}"
   let str_num+=1
done
