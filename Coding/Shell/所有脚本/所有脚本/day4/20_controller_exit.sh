#!/bin/bash
# 功能: exit语句实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制一个内容的判断
for i in {1..4}
do
  if [ $i == "3" ]
  then
     exit 88
  else
     echo $i
  fi
done
