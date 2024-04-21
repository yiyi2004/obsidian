多线程——CPU 上下文切换

单线程处理客户端的链接

- DMA 控制器
- 每个连接都是一个文件描述符
- select
	- 创建文件描述符
		- 随机的，最大值
	- bitmap
- poll
- epoll

## Select

![[Snipaste/Pasted image 20240421194511.png]]

- 1024 个
- 一个一个判断需要切换到内核态，然后进行判断
- 所以不如批量处理
- select 是阻塞函数

![[Snipaste/Pasted image 20240421194922.png]]

![[Snipaste/Pasted image 20240421195143.png]]

1. fdset 1024
2. 不可重入，每次都需要创建新的 rset
3. 内核态和用户态的切换
4. 每次遍历内核返回的 fdset

![[Snipaste/Pasted image 20240421195703.png]]

---

![[Snipaste/Pasted image 20240421200255.png]]  
![[Snipaste/Pasted image 20240421200411.png]]

![[Snipaste/Pasted image 20240421200705.png]]

多线程处理的问题：

![[Snipaste/Pasted image 20240421201041.png]]

同步非阻塞 IO

![[Snipaste/Pasted image 20240421201232.png]]

![[Snipaste/Pasted image 20240421201509.png]]

处理方式

1. 主线程处理
2. 创建一个子线程去处理

![[Snipaste/Pasted image 20240421201611.png]]

不断 read 系统调用，切换，大量开销

## Select

![[Snipaste/Pasted image 20240421201651.png]]

![[Snipaste/Pasted image 20240421202014.png]]

1. select 实现方法 1： CPU 不断的检查，无用检查比较多，就会影响 CPU 性能
2. 实际
	1. 用户进程阻塞
	2. 网卡
	3. DMA 内存
	4. 中断
	5. 响应中断
		1. IP+ port ---> socket
		2. 保存到 socket 接收队列
		3. 检查 socket 等待队列里面有没有阻塞队列
		4. 如果有，唤醒进程
		5. 然后再检查一次 fd 集合，如果有的话 fd 标记
		6. 返回给用户空间

![[Snipaste/Pasted image 20240421202342.png]]

1. 引用传递

![[Snipaste/Pasted image 20240421202513.png]]

1. 每个进程监听的 fd 比较少 1024 默认，可以改
2. 用户态拷贝到内核态
3. 不知道哪个 fd 是就绪的 on 开销
4. 需要重置，因为传参和返回的参数是不一致的

## Poll

![[Snipaste/Pasted image 20240421202636.png]]

![[Snipaste/Pasted image 20240421202735.png]]

## Epoll

![[Snipaste/Pasted image 20240421202844.png]]

![[Snipaste/Pasted image 20240421202920.png]]

![[Snipaste/Pasted image 20240421203231.png]]

1. wq 等待队列，如果没有就绪，就会阻塞进程，然后添加到阻塞队列里面。
2. 就绪队列，已经就绪事件的列表
3. rbr 红黑树

### epoll_ctl

![[Snipaste/Pasted image 20240421203530.png]]

![[Snipaste/Pasted image 20240421203652.png]]

![[Snipaste/Pasted image 20240421203707.png]]

![[Snipaste/Pasted image 20240421203717.png]]

- 如果有就绪事件

![[Snipaste/Pasted image 20240421203730.png]]

![[Snipaste/Pasted image 20240421203801.png]]

## 水平触发和边缘触发

![[Snipaste/Pasted image 20240421203955.png]]

## 异步 IO

一次调用，准备好数据拷贝到指定位置。但是 linux 不太完善
