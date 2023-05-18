# MSF目录结构

kali终端中输

/usr/share/metasploit-framework

然后输入 ls 查看

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639971401000/1abfa994573e4ec1b283aea5ecb809d3.png)


![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639971401000/13fa9f11a9b540f7a15854b67186ae99.png)

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639971401000/15e181b7c7534f549cbbcb249121acb5.png)

# 要记住的一些模块

modules：目录里面存放渗透使用的  辅助模块  编码模块  利用模块  攻击载荷   后渗透模块

plugins： 这个模块需要用load加载，主要提供数据库连接插件 和 各种要用到的插件。

tools：包含一些有用的脚本和零散的工具。

scripts：目录里面存放都是meterpreter利用的脚本。

db：数据放在这个目录里

data：存放使用到的文件，比如密码字典、meterpreter、passivex、vnc、dlls等工具和一些用户接口代码，msfweb和一些其他模块用到的数据文件

lib：库文件都保存在这个目录里
