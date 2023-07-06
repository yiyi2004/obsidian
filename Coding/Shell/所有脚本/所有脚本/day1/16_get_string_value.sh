#!/bin/bash
# 对比 $@ 和 $* 的区别

# 获取相关的信息
echo "@获取的参数内容: $@"
echo "*获取的参数内容: $*"

echo "将@ 传递给子脚本"
/bin/bash 16_chile.sh "$@"

echo "将* 传递给子脚本"
/bin/bash 16_chile.sh "$*"
