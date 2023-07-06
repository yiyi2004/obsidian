#!/bin/bash
# 功能: 函数自调用的目录扫描功能
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 目录扫描的函数
scandir_func(){
  # 定制临时local变量
  local cur_dir workdir
  workdir=$1
  cd ${workdir}
  if [ "${workdir}" == "/" ] 
  then
     cur_dir=""
  else
     cur_dir=$(pwd)
  fi

  # 定制递归扫描逻辑
  for item in $(ls ${cur_dir})
  do
    # 目录文件递归扫描
    if [ -d ${item} ] 
    then
      cd ${item}
      scandir_func ${cur_dir}/${item}
      cd ..
    else
      # 普通文件直接输出
      echo ${cur_dir}/${item}
    fi
  done
}

# 函数调用逻辑
while true
do
  read -p "请输入一个目录(q退出): " dir_value
  if [ -d ${dir_value} ]
  then
     scandir_func ${dir_value}
  elif [ "$dir_value" == "q" ]
  then
     exit
  else
     echo "您输入的不是一个目录，请重新输入!"
  fi
done
