#!/bin/bash
# 功能: 模拟登录界面的认证校验
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 信息的输出
echo -e "\e[31m\t登录界面\e[0m"
echo "==================================="
read -p "请输入登录用户名: " account
read -s -t 30 -p "请输入登录密  码: " password
echo
echo "==================================="

# 输入信息的逻辑判断
[ -z ${account} ] && echo "您输入的账号为空，请重试" && exit
[ ${account} == "root" ] && [ ${password} == "123456" ] && echo "登录成功" || echo "登录失败"
