#!/bin/bash
# 功能: if的扩展条件实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 获取信息
read -p "请输入您的身高: " height
# 逻辑判断
if [[ ! ${height}  =~ ^[1-2].[0-9]{,2}?$ ]]
then
   echo "你确定你有 ${height} 这么高么"
else
   echo "您的身高确定是: ${height}"
fi
