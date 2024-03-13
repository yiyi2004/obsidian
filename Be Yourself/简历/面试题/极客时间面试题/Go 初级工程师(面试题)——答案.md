语法：

什么是闭包?闭包有什么缺陷?  
什么情况下会出现栈溢出?  
什么是不定参数?调用方法的时候，不定参数可以传入 0 个值吗?方法内部怎么使用不定参数?  
什么是 defer?你能解释 - 下 defer 的运作机制吗?  
一个方法内部 defer 能不能超过 8 个?  
defer 内部能不能修改返回值?怎么改?  
数组和切片有什么区别?  
切片怎么扩容的?

Gin  

Gin 面试题  
实际上，Gin 作为简单的框架，能够面试的内容并不多·什么是 Gin 的 middleware?能用来解决什么问题?  
什么是跨域问题，怎么解决?  
跨域问题需要设置哪些头部?  
在 Gin 面试的时候，一定要提起自己研发了一个强大 Gin 插件库

Cookie 关键配置  
你在使用 Cookie 的时候，要注意“安全使用”  
Domain: 也就是 Cookie 可以用在什么域名下，按照最小化原则来设定,Path:cookie 可以用在什么路径下，同样按照最小化原则来设定。Max-Age 和 Expires: 过期时间，只保留必要时间。Http-0nly: 设置为 true 的话，那么浏览器上的」 代码将无法使用这个 Cookie。永远设置为 true。Secure: 只能用于 HTTPS 协议，生产环境永远设置为 true。Samesite: 是否允许跨站发送 Cookie，尽量避免。  
出去面试的时候要详细解释这些参数的含义。在面试初级工程师岗位的时候，会让你赢得微小的竞争优势。

登录流程面试题  
什么是 Cookie，什么是 Session?  
Cookie 和 Session 比起来有什么缺点?  
Session lD 可以放在哪里?这个问题，你要记得提起 Cookie 禁用的问题。  
用户密码加密算法选取有什么注意事项?你用的是什么?  
怎么做登录校验?核心是利用 Gin 的 middleware。

第三周 JWT

![[Snipaste/Pasted image 20240129102233.png]]  
![[Snipaste/Pasted image 20240129102247.png]]  

- kubernetes  

面试要点  
当你出去面试业务研发岗位的时候，Kubernetes 的面试就是集中在一些基本概念上:  
Kubernetes 中的 apiVersion 是什么意思?  
Kubernetes 中 Service、Deployment 和 Pod 的基本概念，能用来干什么?  
Service 的类型有哪几种?有  
什么区别?用在什么场景?  
什么是 ingress? ingress 和 ingress-controller 是什么关系?  
PersistentVolume 和 PersistentVolumeClaim 是什么关系?为什么要有这两个?accessMode 有哪些取值?分别是什么含义?  
正常你在入职一家公司之后，也仅仅是掌握编写 K8s 的配置文件就可以了

第四周

![[Snipaste/Pasted image 20240129102433.png]]  

Redis 面试题目  
你用 Redis 解决过什么问题?  
你知道 Redis 支持哪些数据结构吗?你用过哪些?用来解决什么问题?  
Redis 各个数据结构的底层实现?  
当你更新数据的时候，你先更新数据库，还是先更新缓存?有没有一致性问题?  
如何解决一致性问题?

如何实现一个验证码登录功能  
你的回答要分成以下几个部分:  
简要说明验证码流程的基本步骤，  
详细说明如何保护系统，即防止黑客恶意发送短信，增大成本支出，也要防止验证码被暴力破解重点说明验证码发送/验证流程，强调里面的并发问题，并如何使用 lua 脚本来解决并发问题,  
衍生出来的问题有:  
能不能让用户在输入错误的验证码后继续重试?  
为什么要控制验证码的发送频率?你可以怎么控制?  
如果我在前端加了一个限流措施，能不能保护住我的系统?有什么问题?

面试题目  
这一节课相关的面试内容都是纯理论:  
·什么是依赖注入?如何在 Go 里面是实现依赖注入?  
什么是面向接口编程?为什么要面向接口编程?  
·什么是 loC(控制反转)?  
面试不需要太紧张，因为差不多就是问问基本概念。这一类纯理论的面试难点在于，我作为面试官也不知道怎么面你。

![[Snipaste/Pasted image 20240129102715.png]]  
![[Snipaste/Pasted image 20240129102746.png]]  
![[Snipaste/Pasted image 20240129102808.png]]

第五周

这个问题是什么问题

![[Snipaste/Pasted image 20240129102926.png]]

面试要点  
这一节课的面试要点，核心就在于微信扫码登录的流程。  
·请你说说微信扫码登录的流程。  
为什么微信的回调地址，域名必须是你预先注册的?  
会发生什么?如果我的临时授权码 (也就是 code) 被黑客拿到了，  
state 有什么作用?如何使用 state?  
面试中刷亮点要记住: 绝大部分公司都没有处理 state，所以你要解释清楚，什么情况下不处理 state 会造成跨域问题，以及如何解决。

![[Snipaste/Pasted image 20240129103039.png]]  

![[Snipaste/Pasted image 20240129103124.png]]  

面试要点  
什么是长短 token?为什么要用长短两个 token?  
长短 token 的过期时间应该怎么设置?  
怎么保证长 token 的安全性?万一泄露了怎么办?  
效  
使用 JWT token 怎么退出登录?  
使用了长短 token 之后怎么退出登录?  
使用了 JWT 还需要再使用 Session 吗?  
如果你设计了前面提到的 Gin 插件，那么你在面试过程中就可以一并提起，并且作为你熟知登录过程佐  
证。

面试题目  
直接面试配置模块还是很少见的。如果要问的话，主要可能问: 你们公司是怎么管理配置的?这种问题强调的是你们公司怎么解决不同环境配置的问题  
你们配置的优先级是怎样的?  
你们有没有使用远程中心，用的是哪个?这个按照公司实际情况来回答就可以了，  
如果你已经工作了，并且对 etcd 的原理比较了解，那么可以考虑在简历中写下熟悉 etcd。如果目标公司用云原生比较多，你进去就会大量接触到 etcd。

- etcd 的重要性

![[Snipaste/Pasted image 20240129103322.png]]  
![[Snipaste/Pasted image 20240129111803.png]]  
![[Snipaste/Pasted image 20240129111918.png]]

这一次的面试要点和作业是同一个东西。有一个高频面试题: 如果要你找出按照点赞数量前 N 个数据，怎么做?

第六周

![[Snipaste/Pasted image 20240129112013.png]]  

![[Snipaste/Pasted image 20240129112029.png]]  
![[Snipaste/Pasted image 20240129112045.png]]  

Kafka 面试点  
基本上，你出去面试，Kafka(或者消息队列) 都是必考:  
有没有用过 Kafka?用来解决什么问题?我们后面会有更加复杂的案例你为什么要使用消息队列?使用消息队列的好处是什么?好处就是异步、解耦、削峰请你介绍 - 下 Kafka?要注意介绍 Kafka 中的几个基本概念。包括: 什么是 broker? broker 和 分区的关系是什么?  
什么是 topic? topic 和分区是什么关系?  
Kafka 中 producer 的 acks 有哪些取值?分别是什么含义?你用了哪些?  
Kafka 中的 ISR 是什么意思?  
Kafka 中的一个分区可以有多个消费者吗?  
消息积压了怎么办?基本思路都是异步消费，  
怎么保证消息的顺序?怎么保证全局有序?怎么保证业务有序?

第九周

![[Snipaste/Pasted image 20240129112617.png]]  
![[Snipaste/Pasted image 20240129112631.png]]

第十周

![[Snipaste/Pasted image 20240129112853.png]]  
![[Snipaste/Pasted image 20240129112916.png]]

第十一周

![[Snipaste/Pasted image 20240129113041.png]]  
![[Snipaste/Pasted image 20240129113059.png]]  
![[Snipaste/Pasted image 20240129113112.png]]

第十二周

![[Snipaste/Pasted image 20240129113155.png]]  
![[Snipaste/Pasted image 20240129113230.png]]  
![[Snipaste/Pasted image 20240129113245.png]]  
![[Snipaste/Pasted image 20240129113257.png]]

![[Snipaste/Pasted image 20240129113311.png]]
