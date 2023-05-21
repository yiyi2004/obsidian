- 通过协程提高 CPU 的利用率
- 内核线程和用户线程
- 我们现在称 协程 co-routine

N:1 用不了

- 协程调度器
	- goroutine
	- channel
- runtime 调度
- what the fuck

# GMP
- 默认把所有的核都占用
- M 默认是 10000

![[Snipaste/Pasted image 20230227115326.png]]



# Reference
- https://learnku.com/articles/41728
- [一篇比较好的讲解 Golang GMP 模型的博客，分享给大家_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1a94y1U7xK/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
