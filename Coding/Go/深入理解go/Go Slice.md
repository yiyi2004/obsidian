![[../基础知识/Snipaste/Pasted image 20221120113629.png]]


# 1 append 的性能消耗

![[../基础知识/Snipaste/Pasted image 20221120113808.png]]

![[../基础知识/Snipaste/Pasted image 20221120114113.png]]

![[../基础知识/Snipaste/Pasted image 20221120114154.png]]

- 每天最后一个小时，不论你在做什么，停下来开始复盘今天学过的内容。可以的，

所有内容全都拷贝过来。

![[../基础知识/Snipaste/Pasted image 20221120114520.png]]

![[../基础知识/Snipaste/Pasted image 20221120114857.png]]

![[../基础知识/Snipaste/Pasted image 20221120114921.png]]

- 扩容导致很大的性能损耗

# 2 母子切片内存共享问题
![[../基础知识/Snipaste/Pasted image 20221120115011.png]]

- 子切片进行扩容之后，会和母切片的内存分离

![[../基础知识/Snipaste/Pasted image 20221120115236.png]]

- 通过写代码去验证他们

# 3 切片导致内存泄漏
- 内存泄漏：内存没有按照我们的预期被回收。如果代码被循环调用，会一直开辟新的内存空间，导致内存的使用不断增长。

![[../基础知识/Snipaste/Pasted image 20221120115723.png]]

- 因为 child 切片一直在被使用，所以 parent 切片会一直不被释放，到hi内存泄漏。


![[../基础知识/Snipaste/Pasted image 20221120115858.png]]

![[../基础知识/Snipaste/Pasted image 20221120115917.png]]

- 上诉避免了内存泄漏
- 使用逐个拷贝的方式避免内存绣楼

# 4 函数参数需要切指针嘛
![[../基础知识/Snipaste/Pasted image 20221120120650.png]]

![[../基础知识/Snipaste/Pasted image 20221120120822.png]]


# 5 一边遍历一边修改切片

![[../基础知识/Snipaste/Pasted image 20221120120934.png]]

![[../基础知识/Snipaste/Pasted image 20221120121058.png]]

# Reference
- [马哥教育「官网」-专业Linux云计算运维、云原生、网络安全、GO开发培训机构！ (magedu.com)](https://www.magedu.com/)

想领取本视频配套课件的同学加QQ学习交流群：429823817

【GO二次开发】
Go语言开发实战-kubernetes二次开发实战【高薪必备】
Go语言开发实战-Prometheus定制化二次开发【高薪必备】

【实战视频】
Golang在发光：Go语言开发企业级DevOps平台
Golang开发运维架构项目实战 socker beego websocker 运维 监控
实时分布式消息平台NSQ使用与原理解析
Golang在发光：Syncd系统剖析及企业自动化部署【配套课件见简介】马哥教育系列免费公开课

【面试指导】
Golang在发光：高频面试之channel
golang在发光：Go高频面试之算法
