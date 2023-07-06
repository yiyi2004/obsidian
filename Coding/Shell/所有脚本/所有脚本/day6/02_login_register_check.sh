#!/bin/bash
# 功能: 管理平台登录检测
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 基本信息设定
target_type=(登录 注册)

# 定制信息检测规则
user_rule='^[0-Z@_.]{6,15}$'
pass_rule='^[[0-Z.]{8}'
phone_rule='\<1[3-9][0-9]{9}\>'
email_rule='^[0-Z_]+\@[0-Z]+\.[a-z]{2,3}$'

# 目录信息设定
menu(){
  echo -e "\e[31m\t用户登录注册管理界面\e[0m"
  echo "====================================================="
  echo -e "\e[32m 1: 登录\n 2: 注册\e[0m"
  echo "====================================================="
}
# 检测逻辑函数
check_func(){
  # 接收用户输入数据
  data=$1
  # 接收正则规则
  regex_rule=$2
  # 语法检测逻辑
  echo ${data} | egrep "${regex_rule}" >>/dev/null 2>&1 && echo "true" || echo "false"
}
# 用户登录检测逻辑

# 用户注册检测逻辑
user_register_func(){
  # 接收用户输入
  read -p "请输入注册用户: " register_user
  # 信息的依次检测
  user_status=$(check_func ${register_user} ${user_rule})
  if [ "${user_status}" == "true" ]
  then
     # 用户密码检测
     read -p "请输入注册密码: " register_passwd
     pass_status=$(check_func ${register_passwd} ${pass_rule})
     if [ "${pass_status}" == "true" ]
     then
        # 手机号检测
        read -p "请输入注册手机号: " register_phone
        phone_status=$(check_func ${register_phone} ${phone_rule})
        if [ "${phone_status}" == "true" ]
        then
           # 邮箱地址检测
           read -p "请输入注册邮箱: " register_email
           email_status=$(check_func ${register_email} ${email_rule})
           if [ "${email_status}" == "true" ]
           then
              # 整体信息显示
              echo -e "\e[32m您注册时所有的输入信息如下: "
              echo "注册用户: ${register_user}"
              echo "注册密码: ${register_passwd}"
              echo "注册手机号: ${register_phone}"
              echo -e "注册邮箱: ${register_email}\e[0m"
              read -p "请确认信息输入是否有误[yes|no]: " ack_status
              if [ "${ack_status}" == "yes" ]
              then
                 echo "用户 ${register_user} 注册成功"
              elif [ "${ack_status}" == "no" ]
              then
                 echo "用户 ${register_user} 取消注册"
                 break
              else
                 echo "请再次确认"
              fi
           else
              echo "您输入的邮箱格式有误，请重试"
           fi
        else
           echo "您输入的手机号格式有误，请重试"
        fi
     else
        echo "您输入的密码不符合要求，请重试"
     fi
  else
     echo "用户输入的名称格式有误"
  fi
}
# 脚本帮助逻辑函数
Usage(){
  echo -e "\e[32m请输入符合标准的目标功能id\e[0m"
}

# 程序入口逻辑
while true
do
   menu
   read -p "请输入您要实现的功能(q-退出): " target_id
   if [ "${target_id}" == "q" ] 
   then
      exit
   elif [ "${target_type[${target_id}-1]}" == "登录" ]
   then
      echo "用户登录界面"
   elif [ "${target_type[${target_id}-1]}" == "注册" ]
   then
      user_register_func
   else
      Usage
   fi
done

