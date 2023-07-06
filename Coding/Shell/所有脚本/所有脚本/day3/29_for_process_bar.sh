#!/bin/bash
# 功能: for循环实践进度条
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 准备临时信息
str='#'
myarray=('|' '/' '-' '\\')

# for循环逻辑
for ((i=1; i<=50; i++))
do
  # 准备数组的下标值
  index=$(($i%4))
  # 打印进度条演示
  printf "[%-50s][%3d%%][%c]\r" $str $(($i*2)) ${myarray[index]}
  sleep 0.1
  str+='#'
done

