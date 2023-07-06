#!/bin/bash
# 功能: 简单函数实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 函数定义
func_ok() {
  echo "当前脚本的使用：/bin/bash $0 xxx"
}
func_nook(){
  sssss
}

# 函数调用
if [ $# -eq 1 ]
then
   func_ok
   echo $?
else
   func_nook
   echo $?
fi

