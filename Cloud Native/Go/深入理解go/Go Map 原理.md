![[Pasted image 20221117151839.png]]

# hmap

![[Pasted image 20221117151903.png]]

# bmap

![[Pasted image 20221117151946.png]]

- 第八位和高八位

![[Pasted image 20221117152052.png]]

- 完全不包含指针，减少 gc

![[Pasted image 20221117152406.png]]

# 溢出桶

![[Pasted image 20221117152455.png]]

- 所有的溢出桶是存储在 extra 里面的。

![[Pasted image 20221117152652.png]]

- key value 分开i存储，节省内存空间，但是内存碎片没办法利用了？
- 你值需要一直做，让自己做到麻木为止。

# Reference
- [map 的实现原理 | Go 程序员面试笔试宝典 (golang.design)](https://golang.design/go-questions/map/principal/)
