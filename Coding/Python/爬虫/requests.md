- Time：2023-05-30 19:32
- Label： #爬虫 #python #AI #requests

## Abstract

介绍 requests 以及 requests 进阶内容

1. 浏览器模拟输入 ---> cookie 问题
2. 防盗链处理 ---> 抓取梨视频数据
3. 代理 ---> 方式 IP 被封
4. 接入第三方代理

可以去祸祸那些 VPN 厂商，用他们的代理去爬取数据

我们在之前的爬⾍中其实已经使⽤过 headers 了. header 为 HTTP 协议中的请求头. ⼀般存放⼀些和请求内容⽆关的数据. 有时也会存放⼀些安全验证信息.⽐如常⻅的 User-Agent, token, cookie 等.通过 requests 发送的请求, 我们可以把请求头信息放在 headers 中. 也可以单独进⾏存放, 最终由 requests ⾃动帮我们拼接成完整的 http 请求头

## Content

### Requests Cookie 请求

```python

```

## Reference
