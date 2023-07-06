#!/bin/bash
# 功能: 父脚本传递信息给子脚本

# 定制环境变量

export _xing=zhang
_ming=san
_age=34

echo "父脚本查看变量信息: ${_xing}-${_ming},${_age}"

# 传递信息给子脚本
/bin/bash 09_child.sh

# 接收子脚本修改后的内容
echo "父脚本查看变量信息: ${_xing}-${_ming},${_age}"
