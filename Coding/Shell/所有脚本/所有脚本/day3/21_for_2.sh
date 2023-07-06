#!/bin/bash
# 功能: for语法实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 简单for语法实践
for i in user-{1..3}
do
  echo "您创建的用户有: ${i}"
done
