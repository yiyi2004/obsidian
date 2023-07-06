#!/bin/bash
# 功能: 绘制制定层数的三角形和等腰梯形
# 版本: v0.2
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通信息
graph_array=(三角形 等腰梯形)

# 操作界面提示函数
menu(){
    echo -e "\e[31m绘图类型的展示\e[0m"
    echo "=================================="
    echo "1: 三角形  2: 等腰梯形"
    echo "=================================="
}

# 定制左侧空白的逻辑函数
left_blank_func(){
  # 接收外部函数参数
       nums=$1
       i=$2
       for k in $(seq $[$nums - $i])
       do
          echo -n " "
       done
}

# 定制核心区域的逻辑函数
kernel_character_func(){
       # 接收外部参数
       i=$1
       char=$2
       for j in $(seq $i)
       do
          echo -n "${char}"
       done
}
# 三角形绘制函数
triangle_func(){
    # 定制接收参数
    nums=$1
    # 三角形核心绘制逻辑
    for i in $(seq $nums)
    do 
       # 绘制左侧的空白
       left_blank_func ${nums} $i
       # 绘制核心区域
       kernel_character_func $i "* "
       # 为了保证每一行都是独立的
       echo
    done
}

# 定制梯形的绘制逻辑函数
trapezium_func(){
  # 定制接收参数
    nums=$1
    layer_num=$nums
    for i in $(seq $nums)
    do
       # 绘制左侧的空白
       left_blank_func ${nums} $i
       # 绘制核心区域
       kernel_character_func $layer_num "*"
       let layer_num+=2
       # 为了保证每一行都是独立的
       echo
    done
}

# 定制脚本的帮助信息
Usage(){
  echo -e "\e[31m请输入正确的图形标识\e[0m"
}
while true
do
 # 调用菜单功能函数
 menu
 # 业务主逻辑内容
 read -p  "请输入您要绘制的图形标识: " graph_id
 # 绘制图形逻辑
 case ${graph_array[${graph_id}-1]} in 
  "三角形")
    read -p "请输入您要绘制的图形层数: " nums
    # 绘制三角形
    triangle_func ${nums}
    ;;
  "等腰梯形")
    # 绘制等腰梯形
    read -p "请输入您要绘制的图形层数: " nums
    trapezium_func ${nums}
    ;;
  *)
    Usage;;
 esac
done
