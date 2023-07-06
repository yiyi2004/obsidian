#!/bin/bash
# 功能: 函数和脚本的数组传递的实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制函数 
array_func(){
  # 接收外部的参数数据
  echo "接收函数的所有参数: $@"
  # 合并数组
  new_array=($(echo $@))
  # 查看函数内部的数组
  echo ${new_array[@]}
}
# 定制数组
myarray=(aa bb cc dd ee ff)
echo "脚本内数组的所有元素: ${myarray[@]}"

# 传递数组
array_func ${myarray[@]}
