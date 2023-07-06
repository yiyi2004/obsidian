#!/bin/bash
# 功能: 传参函数实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通参数
arg1="$1"
arg2="$2"

# 定制加减乘除四个函数 
add_func(){
   num1=$1
   num2=$2
   echo $(( $num1 + $num2))
}
sub_func(){
   num1=$1
   num2=$2
   echo $(( $num1 - $num2))
}
mul_func(){
   num1=$1
   num2=$2
   echo $(( $num1 * $num2))
}
div_func(){
   num1=$1
   num2=$2
   echo $(( $num1 / $num2))
}
# 调用四个函数
echo -n "$arg1+$arg2="; add_func $arg1 $arg2
echo -n "$arg1-$arg2="; sub_func $arg1 $arg2
echo -n "$arg1*$arg2="; mul_func $arg1 $arg2
echo -n "$arg1/$arg2="; div_func $arg1 $arg2
