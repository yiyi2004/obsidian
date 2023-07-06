#!/bin/bash
# 功能: 生产环境项目代码的发布脚本
# 版本: v0.2
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
app_dir='app1'

# 文件专属变量
tar_file="${code_name}.tar.gz"
app_file='views.py'
updata_file='django.conf'
pro_port='8000'

# 获取代码
get_code(){
  echo -e "\e[31m获取代码\e[0m"
}

# 校验函数
result_check(){
  status=$1
  message=$2
  if [ ${status} == 0 ]
  then
    echo -e "\e[33m------${message}成功------\e[0m"
  else
    echo -e "\e[33m------${message}失败------\e[0m"
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
  get_code 
  tar_code
  scp_code
  stop_serv
  untar_code
  put_code
  start_serv
  site_check
}
# 主函数
main(){
  site_deploy
}
# 调用主函数
main

