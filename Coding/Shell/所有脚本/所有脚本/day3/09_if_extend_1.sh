#!/bin/bash
# 功能: if的扩展条件实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 获取信息
read -p "请输入一条数据: " num
# 逻辑判断
if (( ${num} % 2  == 0 ))
then
   echo "这是一个偶数"
else
   echo "这是一个奇数"
fi
