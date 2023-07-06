#!/bin/bash
# 功能: 信号的基本操作
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 捕获信号
trap "echo '就不退出,你咬我啊'" SIGINT SIGTERM
# 业务处理
while true
do
  read -p "请输入一个个数据: " value
  echo "输入的数据: $value"
done
