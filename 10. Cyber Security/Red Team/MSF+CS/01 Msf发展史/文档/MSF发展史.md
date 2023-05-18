# 1 Metasploit-发展史

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639966573000/418450a2cc3143c2bb296f73eccb131d.png)

Metasploit框架使Metasploit具有良好的可扩展性，它的控制接口负责发现漏洞、攻击漏洞，提交漏洞，然后通过一些接口加入攻击后处理工具和报表工具。Metasploit框架可以从一个漏洞扫描程序导入数据，使用关于有漏洞主机的详细信息来发现可攻击漏洞，然后使用有效载荷对系统发起攻击，有效载荷就是在发现漏洞之后开发一种可行的攻击方法。其用于提取本地系统密码、安装其他软件或控制硬件等的模块，这些功能很像以前BO2K等工具所具备的功能。



## 2004年

2004年8月，在拉斯维加斯开了一次世界黑客交流会--叫黑帽简报（Black Hat Briefings). 在这个会议上，一款叫Metasploit 的攻击和渗透工具备受众黑客关注，出尽了风头。 Metasploit 是同 HD Moore 和 Spoonm等4名年轻人开发的，这款免费软件可以帮助黑客攻击和控制计算机，安全人员也可以利用 Metasploit 来加强系统对此类工具的攻击。Metasploit 的演示吸引了来自“美国国防部”和“国家安全局”等政府机构的众多安全顾问和个人，正如 Spoonm 在演讲中所说的, Metasploit 很简单，只需要求“找到目标，单击和控制”即可。 2004年 Metasploit 的发布在安全界引发了强烈的“地震”。

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639966573000/a3d942aff8ef42949af2523afdc7fb00.png)

## 2005年

2005年6月，西雅图效区的微软公司总部园区内的管理情报中心，开了一次“蓝帽”会议。几百名微软公司的工程师和众多外界专家及黑客都被邀请进入微软帝国的中心。在会议中的黑客攻击演示中，当 Moore 向系统程序员们说明使用 Metasploit 测试系统对抗入侵的可靠程度时，Metasploit 让微软公司的开发人员再次感到不安。在程序员们看来，Metasploit 将会使系统安全面临严重的考验。 Metasploit (MSF) 在2003年以开放源码方式发布，是可以自由获取的开发框架。它是一个强大的开源平台，提供开发，测试和使用恶意代码，这个环境为渗透测试，为shellcode 编写和漏洞研究提供了一个可靠平台。 Metasploit框架直到2006年发布的2.7版本都用Perl脚本语言编写，由于Perl的一些缺陷，开发者于2007年底使用Ruby语言重写了该框架。到2007年年底，Spoonm和马特·米勒已经离开了项目。从2008年发布的3.2版本开始，该项目采用新的3段式BSD许可证。

## 2009年

2009年10月21号，漏洞管理解决公司Rapid7收购Metasploit项目。Rapid7承诺成立专职开发团队，仍然将源代码置于3段式BSD许可证下。

# 2 BSD许可证

相较于GPL许可证和MPL许可证的严格性，BSD许可证就宽松许多了，一样是只需要附上许可证的原文，不过比较有趣的是，它还要求所有进一步开发者将自己的版权资料放上去，所以拿到以BSD许可证发行的软件可能会遇到一个小状况，就是这些版权资料许可证占的空间比程序还大。

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639966573000/9bc54e5da27644769e8c59836a95aa0c.png)

# 3 Metasploit发展前景

![image.png](https://fynotefile.oss-cn-zhangjiakou.aliyuncs.com/fynote/1985/1639966573000/53ecab99591140878359777a3039a423.png)