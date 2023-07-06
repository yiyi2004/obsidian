#!/bin/bash
# 功能: shell整合expect实践-自动远程登录+用户注册
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制普通变量
login_user='root'
login_psss="123456"
login_file='ip.txt'
new_user='shuji'
new_pass='123456'

# 定制自动化操作流程
cat ${login_file} | while read ip
do
/usr/bin/expect<<-EOF
 set timeout 30
 spawn ssh ${login_user}@${ip}
 expect {
  "*yes/no*" {send "yes\n"; exp_continue}
  "*password*" {send "${login_psss}\n"}
 }
 expect "]#" {send "useradd -m ${new_user}\n"}
 expect "]#" {send "echo ${new_pass} | passwd --stdin ${new_user}\n"}
 expect "]#" {send "id ${new_user}\n"}
 expect "]#" {send "who\n"}
 expect "]#" {send "exit\n"}
 expect eof
EOF
done
