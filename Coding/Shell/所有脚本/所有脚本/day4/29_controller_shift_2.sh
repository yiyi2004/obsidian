#!/bin/bash
# 功能: shift批量创建用户
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 创建普通信息
user_file='/tmp/user.txt'

[ -f $user_file ] && > $user_file

# 创建用户的for逻辑
while [ -n "$1" ]
do
  # 创建用户
  useradd -m $1
  # 定制密码
  passwd=$(head /dev/urandom | tr -dc '[:alnum:]' | head -c8)
  # 用户密码修改
  echo $passwd | passwd --stdin $1 > /dev/null 2>&1
  # 用户信息输出
  echo "用户名: $1, 密码: $passwd" >> $user_file
  echo "用户名 $1 创建完毕"
  # 实现参数转移效果
  shift
done
