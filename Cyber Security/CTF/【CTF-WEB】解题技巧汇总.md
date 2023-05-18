# 解题技巧
## 查看网页源代码
- 就是 F12
## 查看 http 请求/响应  
- hackbar
- 脚本
## HTTP 头相关题目  
- 主要是查看和修改 HTTP 头。  
- 姿势：不同的类型有不同的利用方法，基本都离不开抓包，有些简单的也可以利用浏览器 F12的网络标签解决。但是最根本的应对策略，是熟悉一些常见请求头的格式、作用等，这样考题目的时候就很容易知道要怎么做了。  
- 查看响应头  
- 有时候响应头里会有 hint 或者题目关键信息，也有时候会直接把 flag 放在响应头里给，但是直接查看响应头拿 flag 的题目不多，  
- 只是查看的话，可以不用抓包，用 F12 的“网络”标签就可以解决了。  
## CTF 流量分析：Wireshark 会涉及到。  
  
## 修改请求头、伪造 Cookie
- 常见的有 set-cookie、XFF 和 Referer,总之考法很灵活，做法比较固定，知道一些常见的请求。头再根据题目随机应变就没问题了。有些题目还需要伪造 cookie，根据题目要求做就行了。可以用 Burp 抓包，也可以直接在浏览器的 **F12“网络”标签里改。**
- 域名解析，伪造 host

## 日志审计
- 《006-CTF web 题型总结-第六课 CTF WEB 实战练习(二)》bugku-ctf 第四题：日志审计

## Webshell
- 通过扫描后台路径，发现他人留下的 Webshell

## Web 源码泄露
### vim 源码泄漏(线上 CTF 常见)
- 如果发现页面上有提示 vi 或 vim，说明存在 swp 文件泄漏，地址：/.index.php.swp 或index.php~

### 恢复文件 vim -r index.php，备份文件泄漏
- 地址：index.php.bak，www.zip，htdocs.zip，可以是 zip，rar，tar.gz，7z 等。
- vim -r index.php 是什麽意思呢？



## .git 源码泄露  
- 地址：[http://www.xxx.com/.git/config](http://www.xxx.com/.git/config)，工具：GitHack，dvcs-ripper  

## svn 导致文件泄漏  
- 地址：[http://www/xxx/com/.svn/entries](http://www/xxx/com/.svn/entries)，工具：dvcs-ripper，seay-svn  
- svn: 开放源代码控制系统  

## Git 源码泄露  
- flag 一般在源码的某个文件里，但也有和其他知识结合、需要进一步利用的情况，比如 XCTF 社区的 mfw 这道题。  
- GitHack:It rebuild source code from .git folder while keep directory structure unchanged.  
- 可以根据 Githack 还原文件结构，方便代码审计。  

## 编码和加解密  
- 在线工具或者 burp suite  
- 我记得 burp suite 上面有 Decoder 的模块

## windows 特性，短文件名  
- 利用～字符猜解暴露短文件/文件夹名，如 backup-81231sadasdasasfa.sql 的长文件，其短文件是 backup~1.sql，iis 解析漏洞，绕过文件上传检测  
![[Pasted image 20220915171458.png]]
- [短文件名](https://cloud.tencent.com/developer/article/1541053)  

## PHP 弱类型  

## PHP 伪协议  
- 在 CTF 中经常出现，也经常跟文件包含，文件上传，命令执行等漏洞结合在一起。php 伪协议在第二课会涉及；

## 绕 WAF  
- 大小写混合，使用编码，使用注释，使用空字节  

## Python 爬虫信息处理  
- 这类题目一般都是给一个页面，页面中有算式或者是一些数字，要求在很短的时间内求出结果并提交，如果结果正确就可以返回 flag。因为所给时间一般都很短而且计算比较复杂，所以只能写脚本。这种题目的脚本一般都需要用到 requests 库 BeauifulSoup 库（或者 re 库（正则表达式）），  
- [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc.zh/) or requests  
- web knowledge  
- 爬虫项目 

## PHP 代码审计  
- 归根结底还是要熟练掌握 PHP 这门语言，了解一些常见的会造成漏洞的函数及利用方法等。  
- 所以对 PHP 这么语言还是有点要求的哦。  

## 数组返回 NULL 绕过判断  
- PHP 绝大多数函数无法处理数组，向 md5 函数传入数组类型的参数会使 md5()函数返回NULL（转换后为 False），进而绕过某些限制。如果上面的代码变成：  
- 那么利用弱类型 hash 比较缺陷将无法绕过，这时可以使用数组绕过。传入?a[]=1&b[]=2 就可以成功绕过判断。这样的方法也可以用来绕过 sha1()等 hash 加密函数相关的判断，也可以绕过正则判断，可以根据具体情况来灵活运用。  

## 正则表达式相关
### ereg 正则%00 截断 
- ereg 函数存在 NULL 截断漏洞，使用 NULL 可以截断过滤，所以可以使用%00 截断正则匹配。
- Bugku ereg 正则%00 截断：http://123.206.87.240:9009/5.php
- [ ] PHP 还是要好好学一下哦

### 数组绕过
- 正则表达式相关的函数也可以使用数组绕过过滤，绕过方法详见数组返回 NULL 绕过。上面那道题也可以用数组绕过。

### 单引号绕过 preg_match()正则匹配
- 在每一个字符前加上单引号可以绕过 preg_match 的匹配，原理暂时不明。

## 命令执行漏洞
- 关于web漏洞学习：推荐bwapp：https://sourceforge.net/projects/bwapp/files/bee-box/
- https://blog.csdn.net/qq_37865996/article/details/84987762
- assert() 函数引起的命令执行，
- assert() 函数的参数为字符串的时候，会将其当作一个 PHP 命令来执行
```php
assert("phpinfo()");
<?php phpinfo()?>
```
- **上诉操作等价，但是怎么传递参数呢？**

## XSS 题目
- 《ctf xss注入》《xss game挑战笔记》：http://xss-quiz.int21h.jp/
- 这类题目会涉及到三种 XSS 类型，具体类型要根据题目来判断。一般都是向后台发送一个带有 XSSPayload 的文本，在返回的 Cookie 中含有 flag，解法是在 XSS Payload。这类题目一般都会带有过滤和各种限制，需要了解一些常用的绕过方法。姿势：XSS 归根结底还是 JavaScript，JavaScript 的威力有多大，XSS 的威力就有多大。要知道一些常用的 XSSPayload，还要把三类 XSS 的原理弄明白。做题时需要用到 XSS 平台，网上有公用的，也可以自己在 VPS 上搭一个。
	- 三种 XSS 题目类型的原理
	- 过滤和各种限制 ----> 绕过的常用方法
	- 归根结底是 JS
- JavisOJ babyxss：http://web.jarvisoj.com:32800/

## 绕过 WAF
- 其实绝大多数比较难的题目多多少都会对输入有过滤，毕竟在现实的网络中肯定是会对输入进行限制的，但是这里还是把过滤单独列出来了。
- 姿势：多掌握一些不同的绕过方法。
- [ ] 绕过防火墙的方法

## 长度限制
- 有些题目会要求输入较长的文本，但对文本的长度进行了限制。对于这种题目，既可以用BurpSuite 抓包改包绕过，也可以直接在 F12 里改页面源代码。
- Bugku 计算器（修改页面源代码）：http://123.206.87.240:8002/yanzhengma/
- DVWA 存储型 XSS 的标题栏会对长度进行限制，使用 BurpSuite 抓包绕过。

## 双写
- 双写可以绕过对输入内容过滤的单次判断，在 XSS、SQL 注入和 PHP 代码审计的题目中比较常见。双写顾名思义就是将被过滤的关键字符写两遍，比如，如果要添加 XSSPayload，又需要插入script标签，就可以构造如下的 Payload：<scr\<script>ipt>来绕过对script标签的单次过滤限制。这样的方法不仅对 XSS 有用，也可以用于代码审计和 SQL 注入。HGAME2019 有一道 XSS 题目就是过滤了script，可以用双写绕过
- 可以的，竟然还有这种操作。

## 等价替写
- cat 命令被过滤，可以使用 c%61代替，用 ASCII 码来代替，真有你的。

## URL 绕过
- 如果过滤了某个必须要用的字符串，输入的内容是以 GET 方式获取的（也就是直接在地址栏中输入），可以采用 url 编码绕过的方式。比如，过滤了 cat，可以使用c%61t 来绕过。
- 竟然还有这种操作。用 a 的 ASCII 码来代替。

## Linux 命令使用反斜杠绕过
- 在 Linux 下，命令中加入反斜杠与原命令完全等价。例如，cat 与 ca\t 两条命令等价，效果完全相同。可以利用这个特性来进行一些绕过操作（当然，这个仅限于命令执行漏洞）。

## URL 二次解码绕过
- 如果源码中出现了 urldecode()函数，可以利用 **url 二次解码**来绕过。以下是一些常用的 HTML URL 编码：
- 所以有什么 URL 编码呢？

## 数组绕过
- 详见 PHP **代码审计**的“数组返回 NULL”绕过。数组绕过的应用很广，很多题目都可以用数组绕过。

## 上传绕过
## SQL 注入
- 自动化工具 sqlmap
- 手动注入 SQL

## 爆破

## python 脚本

# 理论基础

# 流量分析

# 实战练习(一)


# 实战练习(二)

# 实战练习(三)

# Burp suite 使用
- 两个文件

# xss 注入

# 信息泄露


# SQL 注入常见题型整理

# HTTP 数据包详解

# xss game 挑战笔记

