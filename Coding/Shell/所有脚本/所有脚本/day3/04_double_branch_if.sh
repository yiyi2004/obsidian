#!/bin/bash
# 功能: 双分支if语句演示
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
gender=$1

# 双if语句框架
if [ "${gender}"  == "nan" ]
then
    echo "您的性别是男性"
else
    echo "您的性别是女性"
fi
