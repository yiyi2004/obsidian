#!/bin/bash
# 功能: 传参函数实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制加减乘除四个函数 
add_func(){
   echo $(( $1 + $2))
}
sub_func(){
   echo $(( $1 - $2))
}
mul_func(){
   echo $(( $1 * $2))
}
div_func(){
   echo $(( $1 / $2))
}

# 调用四个函数
echo -n "3+4="; add_func 3 4
echo -n "3-4="; sub_func 3 4
echo -n "3*4="; mul_func 3 4
echo -n "3/4="; div_func 3 4
