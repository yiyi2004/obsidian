#!/bin/bash
# 功能: while语句读取文件实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

while true
do
  # 定制普通变量
  read -p "请输入文件的路径: " path_name

  # 定制while语句
  cat ${path_name} | while read line
  do
    echo "${line}"
  done
done
