#!/bin/bash
# 功能: 借助函数库文件实现定制层数的三角形和等腰梯形
# 版本: v0.3
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通信息
graph_array=(三角形 等腰梯形)

# 加载函数库文件
source ./lib/*.sh
# 定制图形的核心逻辑
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
