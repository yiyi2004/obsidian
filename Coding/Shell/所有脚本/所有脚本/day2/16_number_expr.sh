#!/bin/bash
# 功能: eq 的语法演示
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com


# 设定普通变量
args_num=$#

# 脚本逻辑判断
[ ${args_num} -eq 1 ] && echo "脚本参数为1，可以执行" || echo "脚本参数不为1，不可以执行"
