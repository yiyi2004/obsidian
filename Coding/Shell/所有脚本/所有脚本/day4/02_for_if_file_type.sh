#!/bin/bash
# 功能: for嵌套if判断文件类型
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
dir_name='dir'

# 定制for嵌套if逻辑
for file in $(ls ${dir_name})
do
  if [ -d ${dir_name}/${file} ]
  then
     echo -e "\e[31m ${dir_name}/${file} 是一个目录文件\e[0m"
  elif [ -f ${dir_name}/${file} ]
  then
     echo -e "\e[32m ${dir_name}/${file} 是一个普通文件\e[0m"
  fi
done
