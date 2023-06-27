## 安装 Ssh

- [(141条消息) 如何在 Ubuntu 20.04 启用 SSH_a_small_cherry的博客-CSDN博客_ubuntu20.04开启ssh](https://blog.csdn.net/a_small_cherry/article/details/122933107?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166635746616781432976467%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166635746616781432976467&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-122933107-null-null.142^v59^control,201^v3^add_ask&utm_term=ubuntu20.04%20ssh&spm=1018.2226.3001.4187)

## Docker

### 卸载 Docker

```shell
1.常归删除操作
sudo apt-get autoremove docker docker-ce docker-engine docker.io containerd runc

2. 删除docker其他没有没有卸载
dpkg -l | grep docker
dpkg -l |grep ^rc|awk ‘{print $2}’ |sudo xargs dpkg -P # 删除无用的相关的配置文件
 
3.卸载没有删除的docker相关插件(结合自己电脑的实际情况)
sudo apt-get autoremove docker-ce-*
 
4.删除docker的相关配置&目录
sudo rm -rf /etc/systemd/system/docker.service.d
sudo rm -rf /var/lib/docker
 
5.确定docker卸载完毕
docker --version
```

### Install

```shell
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
```

```shell
1.x86_64/amd64
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

2.armhf
sudo add-apt-repository \
   "deb [arch=armhf] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
3.arm64
sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

```shell
# 可以另起一个命令窗口 Ctrl + Alt + T
cd /etc/docker/
 
# 查看是否有 daemon.json 文件，没有就创建
ls
 
# 创建 daemon.json 文件
touch daemon.json
 
编辑文件
sudo gedit /etc/docker/daemon.json
 
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
```

```shell
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

```shell
systemctl enable docker # 开机自动启动docker
systemctl start docker # 启动docker
systemctl restart docker # 重启dokcer
systemctl stop docker # 关闭dokcer
```

## 解决问题

### Ssh 服务器拒绝了密码

1. 进入终端窗口（terminal）
2. 进入 root 权限。输入命令:sudo su,回车后输入密码即可。
3. 打开 ssh 服务器的配置文件,输入命令:vi /etc/ssh/sshd_config
4. 在弹出窗口中找到 Authentication,使用 vi 命令修改其中 PermitRootLogin 后的 prohibit-password 为 yes
5. 再次重启 Xshell，然后进行连接就行。

## Reference

- [VMware安裝Ubuntu 16.04.4-server服务器版_运维灬小兵的技术博客_51CTO博客](https://blog.51cto.com/u_4820306/5424903)
- [(80条消息) Ubuntu 20.04.4 Server 图文安装[含磁盘分区]_lm_hao的博客-CSDN博客_ubuntu server 分区](https://blog.csdn.net/llm_hao/article/details/124522423?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166717658816782395342987%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=166717658816782395342987&biz_id=0&spm=1018.2226.3001.4187)
- [ubuntu-releases-18.04安装包下载_开源镜像站-阿里云 (aliyun.com)](http://mirrors.aliyun.com/ubuntu-releases/18.04/)
- [ububtu18.04-server 安装](https://blog.csdn.net/weixin_44088631/article/details/117377300?ops_request_misc=&request_id=&biz_id=102&spm=1018.2226.3001.4187)
