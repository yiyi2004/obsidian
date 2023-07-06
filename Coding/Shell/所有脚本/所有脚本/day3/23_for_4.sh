#!/bin/bash
# 功能: for语法实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 简单for语法实践
for i in $@
do
  echo "您接收的文件脚本参数有: ${i}"
done
