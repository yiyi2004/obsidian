#!/bin/bash
# 功能: kubernetes二进制补助脚本
# 版本: v0.1
# 作者: 书记
# 联系: superopsmsb.com

# 定制基本属性
env_type=(base ha k8s_base master slave)

# 定制信息显示
echo -e "\e[31m     欢迎使用kubernetes部署平台"
echo -e "\e[32m-----------请选择部署阶段-----------
 1: 基础环境部署
 2: 高可用环境部署
 3: kubernetes基础环境部署
 4: 主角色环境部署
 5: 从角色环境部署
----------------------------------\033[0m"

read -p "请输入您要部署的阶段环境: " env_id
case ${env_type[${env_id}-1]} in
  "base")
        echo -e "\e[31m开始基础环境部署..."
        echo "1 执行跨主机免密码操作"
        echo "2 执行时间同步操作"
        echo "3 执行内核配置操作"
        echo -e "4 执行容器私有仓库部署操作\e[0m";;
  "ha")
        echo -e "\e[31高可用环境部署..."
        echo "1 执行高可用环境部署操作"
        echo -e "2 执行负载均衡环境部署操作\e[0m";;
  "k8s_base")
        echo -e "\e[31mkubernetes基础环境部署..."
        echo "1 执行证书管理操作"
        echo "2 执行etcd环境部署操作"
        echo -e "3 执行集群证书配置操作\e[0m";;
  "master")
        echo -e "\e[31m主角色环境部署..."
        echo "1 执行apiserver环境部署操作"
        echo "2 执行scheduler环境部署操作"
        echo "3 执行controller环境部署操作"
        echo "4 执行认证配置操作"
        echo "5 执行容器环境部署操作"
        echo "6 执行kubelet环境部署操作"
        echo -e "7 执行kube-proxy环境部署\e[0m";;
  "slave")
        echo -e "\e[31m从角色环境部署..."
        echo "1 执行容器环境部署操作"
        echo "2 执行kubelet环境部署操作"
        echo -e "3 执行kube-proxy环境部署\e[0m";;
  *)
     echo "请输入有效的阶段环境标识";;
esac
