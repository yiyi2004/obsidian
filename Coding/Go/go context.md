## Context

![[Snipaste/Pasted image 20220921172703.png]]

- Background 在初始化的时候获得一个 context
- TODO 在本应由外部传输的 context，但是没有传到的地方使用 (不明白什么意思捏)

![[Snipaste/Pasted image 20220921172753.png]]  
![[Snipaste/Pasted image 20220921172839.png]]

- 触发取消操作，定时

![[Snipaste/Pasted image 20220921172945.png]]

![[Snipaste/Pasted image 20220921173139.png]]

- 可以通过 context 传递数据

![[Snipaste/Pasted image 20220921173508.png]]

- context 为了更好的去做并发。
- 不要试图修改 context 里面的值。

http 中

- 超时自动取消
- 传递请求相关的数据

![[Snipaste/Pasted image 20220921173711.png]]  
![[Snipaste/Pasted image 20220921173725.png]]

- 学完基本的语法之后就去看一个项目。模仿着去学习。

## Example

1. WaitGroup
2. channel + select
3. context
	1. 取消多个 goroutine

## Reference

- [How To Use Contexts in Go | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-use-contexts-in-go)
- [用 10 分鐘了解 Go 語言 context package 使用場景及介紹_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV17K411H7iw/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
