#!/bin/bash
# 功能: if的扩展条件实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 获取信息
read -p "请输入一个字符串: " string
# 逻辑判断
if [[ ${string}  == v* ]]
then
   echo "匹配成功"
else
   echo "匹配失败"
fi
