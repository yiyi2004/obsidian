#!/bin/bash
# 功能: 函数定制杨辉三角
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
declare -a num_array

# 定制数据检测
check_int(){
  # 定制接收的参数
  layer_num=$1
  tags=true
  while ${tags}
  do
    expr ${layer_num} + 0 >/dev/null 2>&1
    if [ $? -eq 0 ]
    then
      tags=false
    else
      read -p "请输入杨辉三角的层数(q-退出): " layer_num     
    fi
  done
}
# 打印图形左侧空格
left_blank_func(){
    # 接收参数
    layer_num=$1
    row=$2
    # 空白逻辑
    for k in $(seq $[$layer_num-$row])
    do
       # 一行显示所有空白单位
       echo -n "    "
    done
}

# 定制杨辉三角数据内容
triangle_num_count(){
    # 接收数据
    row=$1
    # 定制逻辑
    for ((col=1; col<=row; col++))
    do
       # 行边界数据设定
       if [ $col -eq 1 -o $col -eq $row ]
       then
          num_array[$row$col]=1
       else
         # 行内数据设定
         let row_up=row-1
         let col_up=col-1
         let num_array[$row$col]=num_array[$row_up$col_up]+num_array[$row_up$col]
       fi
    done
}

# 定制杨辉三角数据输出
triangle_num_print(){
    # 接收数据
    row=$1
    # 定制逻辑
    for ((col=1; col<=row; col++))
    do
       printf "%-8s" ${num_array[$row$col]}
    done
    echo
}
# 定制杨辉三角绘制逻辑
triangle_func(){
  # 接收用户数据
  layer_num=$1
  # 杨辉三角绘制
  for ((row=1; row<=layer_num; row++))
  do
    # 空白绘制
    left_blank_func $layer_num $row
    # 数据计算-数组数据添加
    triangle_num_count $row
    # 数据输出-数组数据展示
    triangle_num_print $row
  done
}
# 函数调用逻辑
while true
do
  read -p "请输入杨辉三角的层数(q-退出): " layer_num
  if  [ ${layer_num} != "q" ]
  then
     check_int ${layer_num}
     echo "开始执行绘制"
     triangle_func ${layer_num}
  else
     exit
  fi
done
