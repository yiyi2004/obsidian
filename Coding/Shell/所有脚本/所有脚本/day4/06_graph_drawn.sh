#!/bin/bash
# 功能: 绘制制定层数的三角形和等腰梯形
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通信息
graph_array=(三角形 等腰梯形)

# 操作界面提示
echo -e "\e[31m绘图类型的展示\e[0m"
echo "=================================="
echo "1: 三角形  2: 等腰梯形"
echo "=================================="

read -p  "请输入您要绘制的图形标识: " graph_id
# 绘制图形逻辑
case ${graph_array[${graph_id}-1]} in 
  "三角形")
    read -p "请输入您要绘制的图形层数: " nums
    # 绘制三角形
    for i in $(seq $nums)
    do 
       # 绘制左侧的空白
       for k in $(seq $[$nums - $i])
       do
          echo -n " "
       done
       # 绘制核心区域
       for j in $(seq $i)
       do
          echo -n "* "
       done
       # 为了保证每一行都是独立的
       echo
    done
    ;;
  "等腰梯形")
    # 绘制等腰梯形
    read -p "请输入您要绘制的图形层数: " nums
    layer_num=$nums
    for i in $(seq $nums)
    do
       # 绘制左侧的空白
       for k in $(seq $[$nums - $i])
       do
          echo -n " "
       done
       # 绘制核心区域
       for j in $(seq $layer_num)
       do
          echo -n "*"
       done
       let layer_num+=2
       # 为了保证每一行都是独立的
       echo
    done
    ;;
  *)
    echo -e "\e[31m请输入正确的图形标识\e[0m" 
esac
