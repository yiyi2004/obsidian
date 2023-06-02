## Basic

- http 的升级版本  
![[Pasted image 20220913151346.png]]
- ajax: 轮询模型
- long poll: 阻塞模型，打电话
- websocket 可以互动推送信息给 client  
![[Pasted image 20220913151623.png]]
- 推送的模式，而不是一直连接，需要的时候再建立连接
- Nginx 服务器
- 连接一直存在，直到你关闭连接 (所以知道你的信息)
- 同时由客户主动询问，转换为服务器（推送）有信息的时候就发送（当然客户端还是等主动发送信息过来的。。），没有信息的时候就交给接线员（Nginx），不需要占用本身速度就慢的客服（Handler）了
- 不能在不支持 websocket 的客户端使用 websocket 服务。

## 应用场景

这不是消息队列嘛？

1. websocket 社交订阅
2. websocket 多玩家游戏
3. websocket 协同编辑、编程
4. websocket 收集点击数据流
5. 股票基金报价、使用 websocket 流式更新这些报价
6. 体育实况更新
7. 多媒体聊天
8. 在线教育
9. 论坛消息广播

**一种基于 HTTP 的长链接技术**

## Python Websock



## Reference

- [看完让你彻底搞懂Websocket原理](https://blog.csdn.net/frank_good/article/details/50856585?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166305170616782248561791%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166305170616782248561791&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-2-50856585-null-null.142^v47^pc_rank_34_default_23,201^v3^control_1&utm_term=websocket&spm=1018.2226.3001.4187)
