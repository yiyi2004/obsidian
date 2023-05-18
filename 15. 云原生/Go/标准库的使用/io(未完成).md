![[Pasted image 20221121154144.png]]

# 基础接口

## Reader 接口

![[Pasted image 20221121154437.png]]
![[Pasted image 20221121154507.png]]

- 因为我们，名叫大多数

![[Pasted image 20221121155156.png]]

![[Pasted image 20221121155214.png]]

![[Pasted image 20221121155333.png]]

- 用完之后一定要关闭

# 组合接口
- RW
- RC
- WC
- RWC
- RSeeker
- WS

- ctrl + alt + b 快速查看接口实实现类。

![[Pasted image 20221121155838.png]]
![[Pasted image 20221121155922.png]]
![[Pasted image 20221121155943.png]]
![[Pasted image 20221121160229.png]]


- 在使用 ReadAt 的时候 p 一定是要能够填满的，如果填不满，那么就会一直等待。实际使用中会存在一定问题？这些问题是什么呢？


![[Pasted image 20221121160300.png]]

![[Pasted image 20221121160314.png]]

![[Pasted image 20221121160413.png]]

![[Pasted image 20221121160428.png]]

![[Pasted image 20221121160437.png]]

![[Pasted image 20221121160447.png]]

![[Pasted image 20221121160455.png]]

# 函数示例1
![[Pasted image 20221121161746.png]]

 ![[Pasted image 20221121161902.png]]
![[Pasted image 20221121161917.png]]

![[Pasted image 20221121162014.png]]

![[Pasted image 20221121162027.png]]
![[Pasted image 20221121162037.png]]
![[Pasted image 20221121162125.png]]

- 注意有些文件的读取结束标识符是 err == io.EOF 而不是 nil，但有些是 nil，写代码的时候要注意哦。

![[Pasted image 20221121162803.png]]

- io.Copy 是经常使用的。

![[Pasted image 20221121162836.png]]

![[Pasted image 20221121162920.png]]

- 类似于 body  = append(body, buffer[:n]...)

![[Pasted image 20221121163137.png]]
![[Pasted image 20221121163148.png]]

![[Pasted image 20221121163214.png]]

![[Pasted image 20221121163448.png]]

![[Pasted image 20221121163528.png]]

![[Pasted image 20221121163543.png]]

![[Pasted image 20221121163600.png]]

![[Pasted image 20221121163639.png]]

![[Pasted image 20221121163726.png]]

![[Pasted image 20221121163803.png]]

- 复制到所有的写入器中，这是个不错的功能。

# 函数示例2

![[Pasted image 20221121164149.png]]

![[Pasted image 20221121165130.png]]

- ReadALl

![[Pasted image 20221121165331.png]]

![[Pasted image 20221121165443.png]]

# 注意你最后一节没有看哦
