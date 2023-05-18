**MSF图形化界面Viper(炫彩蛇)下载与使用**

Viper是一款图形化内网渗透工具,将内网渗透过程中常用的战术及技术进行模块化及武器化.

集成杀软绕过,内网隧道,文件管理,命令行等基础功能.

当前已集成70+个模块,覆盖初始访问/持久化/权限提升/防御绕过/凭证访问/信息收集/横向移动等大类.

**在Kali Linux上安装Docker**

 apt-get update

 #使用apt安装docker 

apt-get install -y docker.io 

#设置开机启动 systemctl start docker

 #检查启动状态 docker version              

![1640043246556](1640043246556.png)

 **安装docker-compose**

curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose

 #给赋可执行状态 chmod +x /usr/bin/docker-compose              

![1640043297604](1640043297604.png)

 \#设置安装目录

 export VIPER_DIR=/root/VIPER

 #执行如下命名生成安装目录,并进入安装目录 

mkdir -p $VIPER_DIR && cd $VIPER_DIR              

![1640043341743](1640043341743.png)

**执行如下命令生成docker-compose.yml**

如果你看到的命令是乱的  https://note.youdao.com/s/GdzSJnWD  看这个文档

 tee docker-compose.yml <<-'EOF' version: "3" services:  viper:    image: registry.cn-shenzhen.aliyuncs.com/toys/viper:latest    container_name: viper-c    network_mode: "host"    restart: always    volumes:      - ${PWD}/loot:/root/.msf4/loot      - ${PWD}/db:/root/viper/Docker/db      - ${PWD}/module:/root/viper/Docker/module      - ${PWD}/log:/root/viper/Docker/log      - ${PWD}/nginxconfig:/root/viper/Docker/nginxconfig    command: ["VIPER_PASSWORD"] EOF              

![1640043385926](1640043385926.png)

**设置登录密码**

Viper不允许使用默认密码,diypassword替换为自定义密码密码

  export VIPER_PASSWORD=输入你的密码              

![1640043439186](1640043439186.png)

**写入密码到docker-compose.yml**

sed -i "s/VIPER_PASSWORD/$VIPER_PASSWORD/g" docker-compose.yml

#使用命令查看一下配置 

cat docker-compose.yml                

![1640043478861](1640043478861.png)



**创建启动Viper**

cd $VIPER_DIR docker-compose up -d 

启动viper

 docker-compose start                

![1640043509764](1640043509764.png)

**等待15s系统启动,访问** 

- **https://ip:60000**
-  登录. 用户名:root 密码: 自定义密码

在终端内输入  ip a 查看本机ip

- **我的IP是192.168.3.31  那么我在浏览器里就访问  https://192.168.3.31:60000  登录名是  root  密码是  我上面设置的root** 

![1640043540568](1640043540568.png)



例如： 我的ip是 192.168.3.31  那么访问炫彩蛇的IP就是 192.168.3.31:60000



**注意：**

**所有的docker-compose命令必须在安装目录执行才会有效果**

