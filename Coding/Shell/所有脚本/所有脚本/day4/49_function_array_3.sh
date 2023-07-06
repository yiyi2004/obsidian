#!/bin/bash
# 功能: 函数和脚本的数组传递的实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制函数 
array_func(){
  new_array=($(echo $@))
  # 构造新数组
  for ((i=0; i<${#new_array[@]}; i++))
  do
    # 以独立元素的方法定制新数组元素
    funcarray[$i]=$[ ${new_array[$i]} * 3 ]
  done
  # 输出新数组元素
  echo ${funcarray[@]}
}
# 定制数组
myarray=(1 2 3 4 5)
echo "脚本内数组的所有元素: ${myarray[@]}"

# 传递数组
# array_func ${myarray[@]}

# 接收函数内部传递的数组
result=($(array_func ${myarray[@]}))
echo ${result[@]}
