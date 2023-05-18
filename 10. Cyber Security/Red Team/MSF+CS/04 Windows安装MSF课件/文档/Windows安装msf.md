# 1  下载metasploit

 首先咱们进入metasploit官网

https://www.metasploit.com/

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639970354000/de0dfa24cf144e319e9817208d796e67.png)

点击 Download  下载

或者直接访问这个 地址

https://www.metasploit.com/download

进入这个页面  点击 Metasploit Framework  下面的 Download

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639970354000/40c70142eedd4ee7b6a132a84426dd1f.png)

会访问这个地址

https://github.com/rapid7/metasploit-framework/wiki/Nightly-Installers

如果你不能打开GitHub 我们可以通过镜像服务器 访问

https://hub.fastgit.org/rapid7/metasploit-framework/wiki/Nightly-Installers


![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639970354000/a6096a53fc0f411fa7d4a1ecb32bea1a.png)

这边给大家提供更多的国内可用镜像

#官网镜像（可以用来clone push等,但是不能登录）

https://github.com.cnpmjs.org/
https://git.sdut.me/

#github常用的镜像

https://hub.fastgit.org

https://git.sdut.me/

http://github-mirror.bugkiller.org/
#api镜像
https://api.git.sdut.me/


然后找到Windows版本的下载

点击 latest Windows installer 下载  最新版本

点击  view older builds   下载历史版本

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639970354000/cd3b851b93854b55b549028fa9fb61f9.png)



# 2 安装metasploit并配置环境变量

安装前关闭win自带的杀毒 和卸载第三方杀毒

添加环境变量

C:\metasploit-framework\bin

# 3 启动并使用

首次启动 需要初始化数据库

终端中输入 msfdb init

启动MSF框架

终端中输入 msfconsole