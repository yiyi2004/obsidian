#!/bin/bash
# 功能：显示父脚本传递的信息

echo "接收父脚本查看变量信息: ${_xing}-${_ming},${_age}"

# 定制子脚本相关信息
export _xing=li
_ming=ming
_age=15

echo "子脚本查看变量信息: ${_xing}-${_ming},${_age}"
