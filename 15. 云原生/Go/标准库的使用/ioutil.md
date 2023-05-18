![[Pasted image 20221121165620.png]]

- io.ReadAll 在遇到大文件的时候性能可能不太好 ---> 那应该怎么操作呢？

![[Pasted image 20221121165904.png]]

![[Pasted image 20221121165916.png]]

![[Pasted image 20221121170055.png]]

- 把之前的内容清空

![[Pasted image 20221121170122.png]]

![[Pasted image 20221121170211.png]]

![[Pasted image 20221121170420.png]]

![[Pasted image 20221121170435.png]]


- 一般来说都是转成 []byte 数组操作的。

