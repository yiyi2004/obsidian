#!/bin/bash
# 功能: vsftpd环境部署实践
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 设定基础环境变量
target_type=(部署 下载 操作)
network_file='/etc/sysconfig/network'
host_file='/etc/hosts'
vsftpd_home='/etc/vsftpd'
vsftpd_conf='vsftpd.conf'
vsftpd_dir='/var/ftp'
vsftpd_pub='pub'

# 设定通用的命令变量
ip_addr=$(ifconfig eth0 | sed -n '2p' | sed 's/.*net \(.*\)  net.*/\1/')
ip_tail=$(echo $ip_addr | cut -d '.' -f4)
host_name="server${ip_tail}.localhost.com"


# 设定目录内容函数
menu(){
  echo -e "\e[31m\tvsftpd软件管理界面\e[0m"
  echo "====================================================="
  echo -e "\e[32m 1: 部署   2: 下载测试   3：操作测试 \e[0m"
  echo "====================================================="
}

# 设定主机名准备工作
base_env_func(){
  echo "HOSTNAME=${host_name}" >> ${network_file}
  echo "${ip_addr} ${host_name}" >> ${host_file}
  hostnamectl set-hostname ${host_name}
  echo -e "\e[33m主机名操作流程执行完成\e[0m"
}
# 设定软件安装函数
softs_install_func(){
  read -p "请输入要安装的软件[多个软件使用空格隔开]: " soft_name
  yum install -y ${soft_name} >> /dev/null 2>&1 && echo "${soft_name} 安装成功" || (echo "${soft_name} 安装失败" && exit)
  echo -e "\e[33m软件安装操作流程执行完成\e[0m"
}
# 设定软件的配置函数
softs_conf_func(){
  # 备份文件
  cp ${vsftpd_home}/${vsftpd_conf}{,.bak}
  # 清理无效信息
  sed -i '/^#/d;/^$/d' ${vsftpd_home}/${vsftpd_conf}
  # 配置的修改
  sed -i '/local_enable/c\local_enable=NO' ${vsftpd_home}/${vsftpd_conf}
  sed -i '$a anon_upload_enable=YES' ${vsftpd_home}/${vsftpd_conf}
  sed -i '$a anon_mkdir_write_enable=YES' ${vsftpd_home}/${vsftpd_conf}
  sed -i '$a anon_other_write_enable=YES' ${vsftpd_home}/${vsftpd_conf}
  sed -i '$a anon_max_rate=512000' ${vsftpd_home}/${vsftpd_conf}
  echo -e "\e[33m软件配置操作流程执行完成\e[0m"
}

# 软件服务重启函数
service_restart_func(){
  # 服务的重启
  systemctl restart vsftpd >> /dev/null 2>&1 && echo "vsftpd服务重启成功" || (echo "vsftpd服务重启失败" && exit)
}
# 软件部署函数
soft_deploy_func(){
 base_env_func
 softs_install_func
 softs_conf_func 
 service_restart_func
 echo -e "\e[33m软件部署操作流程执行完成\e[0m"
}
# 设定下载测试函数
download_file_func(){
  # 文件权限设定
  chmod 777 ${vsftpd_dir}/${vsftpd_pub}
  cp ${host_file} ${vsftpd_dir}/${vsftpd_pub}/
  # 文件下载测试
  cd /tmp
  /usr/bin/lftp ${ip_addr} <<- eof
  cd pub
  get hosts
  exit
	eof
}
# 设定操作测试函数
operator_file_func(){
  # 文件操作测试
  /usr/bin/lftp ${ip_addr} <<- eof
  cd pub
  mkdir test1
  mkdir test2
  rm -rf test2
  put /etc/group
  exit
	eof
}
# 设定主逻辑函数

# 设定帮助函数
Usage(){
   echo "请输入正确的操作步骤标识"
}
# 设定脚本入口逻辑
while true
do 
  menu
  read -p "请输入待操作的步骤标识(q-退出): " target_id
  if [ "${target_id}" == "q" ]
  then
     echo "退出vsftpd操作"
     exit
  elif [ "${target_type[${target_id}-1]}" == "部署" ]
  then
     echo "vsftpd软件部署"
     soft_deploy_func    
  elif [ "${target_type[${target_id}-1]}" == "下载" ]
  then
     echo "vsftpd环境下载测试"
     download_file_func
     # 测试动作之后，判断效果
     if [ -f /tmp/hosts ] 
     then
        echo -e "\e[33m匿名用户环境下载测试成功\e[0m"
        # 清理测试环境
        rm -f /tmp/hosts
     else
        echo -e "\e[33m匿名用户环境下载测试失败\e[0m"
     fi
  elif [ "${target_type[${target_id}-1]}" == "操作" ]
  then
     echo "vsftpd环境操作测试"
     operator_file_func
     if [ -d ${vsftpd_dir}/${vsftpd_pub}/test1 ]
     then
        if [ ! -d ${vsftpd_dir}/${vsftpd_pub}/test2 ]
        then
           if [ -f ${vsftpd_dir}/${vsftpd_pub}/group ]
           then
              echo -e "\e[33m匿名用户环境操作测试成功\e[0m"
              # 清理测试环境
              rm -rf ${vsftpd_dir}/${vsftpd_pub}/*
           else
              echo -e "\e[33m匿名用户环境操作测试失败\e[0m"
           fi
        fi      
     fi
  else
     Usage
  fi
done
