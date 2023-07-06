#!/bin/bash
# 功能: for批量创建用户
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 创建普通信息
user_file='/tmp/user.txt'

[ -f $user_file ] && > $user_file

# 创建用户的for逻辑
for i in {1..5}
do
  # 创建用户
  useradd -m user-$i
  # 定制密码
  passwd=$(head /dev/urandom | tr -dc '[:alnum:]' | head -c8)
  # 用户密码修改
  echo $passwd | passwd --stdin user-$i > /dev/null 2>&1
  # 用户信息输出
  echo "用户名: user-$i, 密码: $passwd" >> $user_file
  echo "用户名 user-$i 创建完毕"
done
