#!/bin/bash
# 功能: for批量创建用户
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 删除用户的for逻辑
for i in {1..5}
do
  # 删除用户
  userdel -r user-$i >/dev/null 2>&1
  # 信息输出
  echo "用户名 user-$i 删除完毕"
done
