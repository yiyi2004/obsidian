#!/bin/bash
# 有条件的默认值

# 定制普通变量
arg=$1

echo "您选择的手机套餐是: ${arg:-1} 套餐"
