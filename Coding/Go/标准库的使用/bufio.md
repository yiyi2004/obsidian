![[Snipaste/Pasted image 20221122084835.png]]

- 提供了有缓冲的操作

## 原理

![[Snipaste/Pasted image 20221122085043.png]]  
![[Snipaste/Pasted image 20221122085115.png]]

## Reader

![[Snipaste/Pasted image 20221122085212.png]]  
![[Snipaste/Pasted image 20221122085308.png]]  
![[Snipaste/Pasted image 20221122085320.png]]  
![[Snipaste/Pasted image 20221122085402.png]]

- example

![[Snipaste/Pasted image 20221122085423.png]]

![[Snipaste/Pasted image 20221122085713.png]]

![[Snipaste/Pasted image 20221122085801.png]]

![[Snipaste/Pasted image 20221122085841.png]]

![[Snipaste/Pasted image 20221122085906.png]]  
![[Snipaste/Pasted image 20221122090011.png]]

- 读中文

![[Snipaste/Pasted image 20221122090036.png]]

![[Snipaste/Pasted image 20221122090100.png]]

![[Snipaste/Pasted image 20221122090331.png]]  
![[Snipaste/Pasted image 20221122092147.png]]  
![[Snipaste/Pasted image 20221122092210.png]]  
![[Snipaste/Pasted image 20221122092221.png]]  
![[Snipaste/Pasted image 20221122092335.png]]  
![[Snipaste/Pasted image 20221122092347.png]]

## Writer

![[Snipaste/Pasted image 20221122114431.png]]

![[Snipaste/Pasted image 20221122114713.png]]

![[Snipaste/Pasted image 20221122114837.png]]

- flush 相当于刷盘，将缓冲区内的数据写入磁盘中，并且恢复初始状态。

![[Snipaste/Pasted image 20221122115117.png]]

- ReadFrom 不需要 Flush。

## ReadWriter

![[Snipaste/Pasted image 20221122120240.png]]

![[Snipaste/Pasted image 20221122120249.png]]

![[Snipaste/Pasted image 20221122120300.png]]

 ![[Snipaste/Pasted image 20221122120443.png]]

![[Snipaste/Pasted image 20221122120743.png]]  
![[Snipaste/Pasted image 20221122120759.png]]

![[Snipaste/Pasted image 20221122150248.png]]

![[Snipaste/Pasted image 20221122150338.png]]

## Scanner

![[Snipaste/Pasted image 20221122150418.png]]

![[Snipaste/Pasted image 20221122150428.png]]  
![[Snipaste/Pasted image 20221122150508.png]]

![[Snipaste/Pasted image 20221122150955.png]]  
![[Snipaste/Pasted image 20221122151013.png]]  
![[Snipaste/Pasted image 20221122151029.png]]  
![[Snipaste/Pasted image 20221122151045.png]]  
![[Snipaste/Pasted image 20221122151109.png]]

![[Snipaste/Pasted image 20221122151139.png]]  
![[Snipaste/Pasted image 20221122151153.png]]

- 中文读的时候用 rune 读

![[Snipaste/Pasted image 20221122151502.png]]
