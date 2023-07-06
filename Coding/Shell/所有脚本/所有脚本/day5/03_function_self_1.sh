#!/bin/bash
# 功能: 函数自调用的基本演示
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 自调用函数的定义
self_func(){
   # 接收数据
   num=$1
   # 递归退出条件
   if [ $num -eq 1 ]
   then
      echo 1
   else
     # 正常的递归逻辑
     local temp=$[$num -1]
     result=$(self_func $temp)
     echo $[ $result * $num ]
   fi
}

# 函数的使用
while true
do
  read -p "请输入您要查看的阶乘数据: " value
  result=$(self_func $value)
  echo "$value的数据阶乘是: ${result}"
done
