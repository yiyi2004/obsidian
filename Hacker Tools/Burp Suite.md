![[Pasted image 20220912155034.png]]

- inetcpl.cpl
- 破解方法 java -jar + …

## 在浏览器中安装 CA 证书

1. 以管理员身份打开浏览器
2. 输入 http://burp/
3. 安装 CA 证书

## Burp Suite Proxy

![[Pasted image 20220912162346.png]]

- WEB 安全测试流程  
![[Pasted image 20220913081338.png]]

## Proxy

1. 代理
2. 处理 HTTP Request
3. 处理 HTTP Response

![[Pasted image 20220913091426.png]]

- 设置 proxy listener 来截断流量，比如设置监听端口  
![[Pasted image 20220913091732.png]]
- 注意两边都要进行设置
- intercept client requests 截断符合条件的 http 请求  
![[Pasted image 20220913091839.png]]
- 优先级问题，上面的优先匹配，真不错哦。
- 整理自己的文献
- **Websocket 的内容需要补充一下。**  
![[Pasted image 20220913092716.png]]
- 匹配以及修改 HTTP 消息
- **正则表达式的知识需要补充一下**
- 设置使用 SSL 连接到 WEB 服务器  
![[Pasted image 20220913093304.png]]
- 杂项设置

### 小结

1. 掌握 burp suite 截断代理设置
2. 充分了解 burp suite proxy 模块使用

## 抓取手机 App 流量

- 手机设置网络代理
- proxy listener 设置 all interface  
![[Pasted image 20220913102630.png]]  
![[Pasted image 20220913164256.png]]
- vivo 如何设置代理

### 小结

1. 截取收集流量 wifi 代理
2. 手机服务 App 和 web 服务是类似的

## 截断剔除 Js 脚本

- 在 repeater 中可以查看
- 出现这种漏洞的工程师，确实有点 2 呀。
- 但是这种方法确实可以绕过 js 在前端的验证。
- 当然，也可以利用浏览器自带工具进行手动的剔除。

### 小结

1. 掌握自动剔除 js 的方法
2. 浏览器审计工具手动剔除

## Target

![[Pasted image 20220913170106.png]]

- Scope  
![[Pasted image 20220913170243.png]]

![[Pasted image 20220913171515.png]]

- 为什么我看不到 sitemap 呢？
- 可以更加直观的看站点的结构。接下来的三年时间，我决定一直学习。

### 小结

1. 掌握 burp suite scope 的设置方法 (但是我还是没有弄清楚.jpg)
2. 掌握 sitemap 的使用 (然而我并没有学会使用.jpg)

## Spider

- 截断之后 action 然后 send to spider

## Q&A

- fuzzing 技术查漏洞

## Reference

- [Burpsuite的使用全面教程](https://www.bilibili.com/video/BV1zY4y1L7HG?p=2&spm_id_from=pageDriver&vd_source=25509bb582bc4a25d86d871d5cdffca3)
