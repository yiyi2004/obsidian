#!/bin/bash
# 功能: for循环实践数据比大小
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 定制普通变量和数组
declare -i max min
declare -a nums

# 最大值和最小值的获取逻辑
for ((i=0; i<10; i++))
do
  # 数组添加数据
  nums[$i]=$RANDOM
  # 设定最大值和最小值的初始值
  [ $i -eq 0 ] && max=${nums[0]} min=${nums[0]}
  # 最大值的判断
  [ ${nums[$i]} -gt $max ] && max=${nums[$i]}
  # 最小值的判断
  [  ${nums[$i]} -lt $min ] && min=${nums[$i]}
done
# 信息的输出
echo "数组所有元素内容: ${nums[@]}"
echo "数组中最大的数据: $max"
echo "数组中最小的数据: $min"
