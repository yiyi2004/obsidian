- 获取靶场上的 flag
- 信息探测 
- nmap -sV ip 挖掘开放服务信息
- service information
- flag 很大程度上是隐藏在 HTML 的源代码中
- dirb http://ip:port/ 探测隐藏文件

![[Pasted image 20221108212901.png]]

- robots.txt 里面存储着不允许搜索引擎探测的文件名和允许被探测的文件名。

![[Pasted image 20221108213907.png]]
- 这个文件中就包含着 flag

![[Pasted image 20221108214028.png]]

![[Pasted image 20221108214104.png]]


![[Pasted image 20221108214135.png]]

- 探测是否存在

![[Pasted image 20221108214205.png]]

![[Pasted image 20221108214301.png]]

- 查看 id_rsa 的权限，是可读可写的。
- 另外一个文件里面隐藏着用户信息。

![[Pasted image 20221108214644.png]]

![[Pasted image 20221108214659.png]]

- 权限问题，需要赋予权限才能进一步操作，这就是所谓的签到题目吧。

![[Pasted image 20221108215033.png]]

![[Pasted image 20221108215109.png]]

![[Pasted image 20221108215212.png]]

![[Pasted image 20221108215248.png]]

- CTF 中 root 目录一定要注意
- cd root, cat flag.txt permision denied

![[Pasted image 20221108215401.png]]
- 提升权限

![[Pasted image 20221108215546.png]]
![[Pasted image 20221108215720.png]]

```shell
cat read_message.c
```

![[Pasted image 20221108220015.png]]

![[Pasted image 20221108220229.png]]

- 为什么溢出会获取 /bin/bash 会获取 root 权限啊？我不理解。
- 逐步深入的挖掘有用的信息。而不是直接利用一个漏洞，直接获取所有的权限，所以要利用题目的提示。