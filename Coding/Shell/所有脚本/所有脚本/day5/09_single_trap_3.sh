#!/bin/bash
# 功能: 信号的基本操作
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 捕获信号
trap "echo '走咯，上西天咯'" EXIT

# 业务处理
i=1
while [ $i -lt 4 ]
do
  read -p "请输入一个个数据: " value
  if [ "${value}" == "9" ] 
  then
     echo "走了"
     exit
  else
    echo "输入的数据: $value"
  fi
  let i+=1
done

# 移除捕获
trap - EXIT

echo "还原了捕获的原信号信息"
