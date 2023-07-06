#!/bin/bash
# 功能: shift语句实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# until 循环实践
until [ -z "$1" ]
do 
   echo "$1, $#"
   # 获取参数之后，就剔除，进行下一个数据的获取
   shift
done
