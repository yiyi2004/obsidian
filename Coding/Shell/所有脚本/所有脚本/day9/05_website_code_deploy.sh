#!/bin/bash
# 功能: 生产环境项目代码的发布脚本
# 版本: v0.5
# 作者: 书记
# 联系: superopsmsb.com

# 定制基础变量
remote_host='10.0.0.13'
remote_user='root'
remote_script='03_website_tar_code.sh'

# 目录专属变量
code_dir='/data/codes'
code_name="django"
scripts_dir='/data/scripts'
nginx_conf_dir='/etc/nginx/default.d'
backup_dir='/data/backup'
site_dir='/data/server/web_site'
log_dir='/data/logs'
app_dir='app1'

# 文件专属变量
tar_file="${code_name}.tar.gz"
app_file='views.py'
updata_file='django.conf'
log_file="${log_dir}/deploy.log"
lock_file='/tmp/deploy.pid'

# 其他变量
pro_port='8000'
func_arg="$1"


# 删除锁文件
# 日志输出函数
write_log(){
  # 获取函数参数值
  current_step=$1
  current_date=$(date +%F)
  current_time=$(date +%T)
  echo "${current_date} ${current_time} $0 ${current_step}" >> ${log_file}
}

# 增加锁文件
add_lock(){
  echo -e "\e[33m增加锁文件\e[0m"
  touch ${lock_file}
  write_log "增加锁文件"
}

# 删除锁文件
del_lock(){
  echo -e "\e[33m删除锁文件\e[0m"
  rm -f ${lock_file}
  write_log "删除锁文件"
}

# 获取代码
get_code(){
  echo -e "\e[31m获取代码\e[0m"
  write_log "获取代码"
}

# 校验函数
result_check(){
  status=$1
  message=$2
  if [ ${status} == 0 ]
  then
    echo -e "\e[33m------${message}成功------\e[0m"
    write_log "${message}成功"
  else
    echo -e "\e[33m------${message}失败------\e[0m"
    write_log "${message}失败"
    exit
  fi
}

# 打包代码
tar_code(){
  echo -e "\e[31m打包代码\e[0m"
  ssh ${remote_user}@${remote_host} "/bin/bash ${scripts_dir}/${remote_script}"
  result_check $? "打包代码"
}

# 传输代码
scp_code(){
  echo -e "\e[31m传输代码\e[0m"
  scp ${remote_user}@${remote_host}:${code_dir}/${tar_file} ${code_dir}
  result_check $? "传输代码"
}
# 关闭应用
stop_serv(){
  echo -e "\e[31m关闭相关的应用环境\e[0m"
  echo -e "\e[32m调整Nginx应用环境\e[0m"
  sed -i '/localhost/s/proxy_pass/# proxy_pass/' ${nginx_conf_dir}/${updata_file}
  sed -i '/6666/s/# proxy_pass/proxy_pass/' ${nginx_conf_dir}/${updata_file}
  systemctl restart nginx
  echo -e "\e[32m调整Django应用环境\e[0m"
  kill $(lsof -Pti :${pro_port})
  result_check $? "关闭应用"
}
# 解压代码
untar_code(){
  echo -e "\e[31m解压代码\e[0m"
  cd ${code_dir}
  tar xf ${tar_file} 
  result_check $? "解压代码"
}
# 放置代码
put_code(){
  echo -e "\e[31m放置代码\e[0m"
  echo -e "\e[32m备份老文件\e[0m"
  mv ${site_dir}/${app_dir}/${app_file} ${backup_dir}/${code_name}/${app_file}-$(date +%Y%m%d%H%M%S)
  echo -e "\e[32m放置新代码\e[0m"
  mv ${code_dir}/${code_name}/${app_file} ${site_dir}/${app_dir}/${app_file}
  result_check $? "放置代码"
}
# 开启应用
start_serv(){
  echo -e "\e[31m开启相关的应用环境\e[0m"
  echo -e "\e[32m调整Nginx应用环境\e[0m"
  sed -i '/localhost/s/# proxy_pass/proxy_pass/' ${nginx_conf_dir}/${updata_file}
  sed -i '/6666/s/proxy_pass/# proxy_pass/' ${nginx_conf_dir}/${updata_file} 
  systemctl restart nginx
  echo -e "\e[32m调整Django应用环境\e[0m"
  source /data/virtual/venv/bin/activate
  python ${site_dir}/manage.py runserver >>/dev/null 2>&1 &
  deactivate
  result_check $? "开启应用"
}
# 内部检测
site_check(){
  echo -e "\e[31m代码发布完成，内部检测\e[0m"
  curl -s localhost/hello/ | grep web >>/dev/null 2>&1
  result_check $? "内部检测"
}
# 总部署函数
site_deploy(){
  add_lock
  write_log "代码发布开始"
  get_code 
  tar_code
  scp_code
  stop_serv
  untar_code
  put_code
  start_serv
  site_check
  write_log "代码发布结束"
  del_lock
}

# 定制帮助信息函数
error_message(){
  echo "脚本 $0 正在使用，请稍后"
}

# 脚本帮助函数
Usage(){
  echo "脚本帮助信息: /bin/bash $0 [deploy | rollout]"
}

# 主函数
main(){
  func_name="$1"
  case "${func_name}" in
    "deploy")
      if [ -f ${lock_file} ]
      then
        error_message
      else
        site_deploy
      fi;;
   "rollout")
      echo "执行代码回滚动作";;
   *)
      Usage;;
  esac
}
# 调用主函数
main "${func_arg}"

