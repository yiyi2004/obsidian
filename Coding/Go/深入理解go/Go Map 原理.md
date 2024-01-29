![[Snipaste/Pasted image 20221117151839.png]]

## Hmap

![[Snipaste/Pasted image 20221117151903.png]]

## Bmap

![[Snipaste/Pasted image 20221117151946.png]]

- 第八位和高八位

![[Snipaste/Pasted image 20221117152052.png]]

- 完全不包含指针，减少 gc

![[Snipaste/Pasted image 20221117152406.png]]

## 溢出桶

![[Snipaste/Pasted image 20221117152455.png]]

- 所有的溢出桶是存储在 extra 里面的。

![[Snipaste/Pasted image 20221117152652.png]]

- key value 分开 i 存储，节省内存空间，但是内存碎片没办法利用了？
- 你值需要一直做，让自己做到麻木为止。

## 原理

1. hash
	1. 移位
	2. 开链法
	3. 开树法
	4. 多次 hash
2. go map
	1. hmap
		1. bucket：array
		2. B：B 是 buckets 数组的长度的对数
		3. extra 溢出桶数据的位置
		4. old bucket
		5. count
		6. hash0
	2. bucket n 个 bmap
		1. B = 1 2^B(指的有多少个 bmap)
		2. bmap 8 kv
			1. tophash
				1. keysX8
				2. valuesX8
				3. next ---> 指向 overflow 溢出桶
	3. 查的过程
		1. hash(key) ---> hashcode ---> hashcode %(2^B)-1 ---> 找到分配到哪个桶
		2. hashcode 高八位 ---> **tophash** ---> 比对 bmap 中的 tophash
			1. 数字的比对更快
		3. 比对 key，如果相同，返回回来，如果查不到
	4. tophash 0 ~ 5 是空出来的，代表一种状态
		1. 6 ~ 255
		2. 0 ---> 当前没有值，后面也没有值
		3. 1 ---> 后面一定有值 delete ---> 1
		4. hashcode ---> bucket
3. 写、删 ---> 扩容
	1. 扩容因子
	2. 溢出桶的数量 overflow bucket
	3. 等量扩容：认为 hash 分布不均匀就会进行等量扩容，hash 利用率比较低 (溢出桶比较多)
		1. hash 重新分布
	4. 增量扩容
		1. 内存使用不可控
4. 遍历：遍历是随机的，伪随机的
	1. hiter ---> start bucket
		1. start bucket 随机选择一个 start bucket
		2. 遍历是顺序的
	2. 为什么做成随机的，防止扩容之后顺序改变，让开发者不依赖于 map 的顺序
5. fast_map 单独的优化
	1. int64 不比对 tophash，直接比对 key
	2. int32
	3. string 先比对 length
6. 常见面试题
	1. map 使用的注意点
		1. 未初始化的时候，读的 0 值，写的时候会 panic
		2. 并发不安全的，使用 Mutex 或者使用 sync.Map
			1. 通过 flags 和 并发标记
			2. ![[Snipaste/Pasted image 20240129145202.png]]
		3. 循环时无序的
		4. 长时间使用固定的 map 进行增删，有可能导致 map 占用的内存特别大，导致 GC 问题。
	2. map 循环有序还是无序？是严格随机的嘛？
		1. hiter 随机找到第一个 bucket
		2. 不是，伪随机的，只有 bucket 的选择是随机的
	3. map 的底层结构
		1. hmap ---> bucket extra bmap
	4. 如何扩容的
		1. 增量扩容
		2. 等量扩容
		3. add / delete 触发扩容
		4. 并不是一次完成的，是渐进式的扩容
		5. 2 倍的扩容
		6. 标记是否已经 rehash，渐进式 rehash。
		7. growork

![[Snipaste/Pasted image 20240129141016.png]]

## Reference

- [map 的实现原理 | Go 程序员面试笔试宝典 (golang.design)](https://golang.design/go-questions/map/principal/)
- [golang map详细讲解与常见面试题解答_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1ng411v7uE/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
