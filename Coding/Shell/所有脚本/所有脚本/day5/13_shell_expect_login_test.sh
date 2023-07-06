#!/bin/bash
# 功能: shell整合expect实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# shell定制普通变量
login_user='python'
login_pass='123456'
login_host='10.0.0.12'

# shell整合expect逻辑
expect <<-eof
  # 发起子进程
  spawn ssh ${login_user}@${login_host}
  # 关键字匹配
  expect {
     "yes/no" { send "yes\n"; exp_continue }
     "password:" {send "${login_pass}\n"}
  }
  # 退出expect环境
  puts ""
  puts "ssh登录测试完毕"
  expect eof
eof
