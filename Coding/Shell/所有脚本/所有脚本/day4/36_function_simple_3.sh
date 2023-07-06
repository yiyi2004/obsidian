#!/bin/bash
# 功能: 简单函数实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 函数定义
Usage() {
  echo "当前脚本的使用：/bin/bash $0 xxx"
}
echo "第一次调用"
Usage

Usage() {
  echo "------------------当前脚本的使用：/bin/bash $0 xxx"
}
# 函数调用
if [ $# -eq 1 ]
then
   echo "脚本执行"
else
   Usage
fi
