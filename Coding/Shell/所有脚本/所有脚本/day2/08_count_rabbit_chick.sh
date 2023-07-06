#!/bin/bash
# 功能: 鸡兔数学运算
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
head_num=$1
feet_num=$2

# 运算鸡和兔
rabbit_num=$(( ($feet_num - $head_num -$head_num) / 2))
chick_num=$(( $head_num - $rabbit_num ))

# 信息输出
echo "------------------------------"
echo -e "\e[31m: 兔子的数量: \e[0m" ${rabbit_num}
echo -e "\e[31m: 小鸡的数量: \e[0m" ${chick_num}
echo "------------------------------"
