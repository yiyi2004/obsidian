# 基础
![[Pasted image 20221120095904.png]]

- 做时间的时候一定要考虑时区问题。

![[Pasted image 20221120100013.png]]

![[Pasted image 20221120100241.png]]

# Unix 时间戳
- UTC 时间

![[Pasted image 20221120101054.png]]


# Parse 解析时间

![[Pasted image 20221120101148.png]]

![[Pasted image 20221120101329.png]]

- go 的诞生时间
- 下次安装环境的时候一定要搭建时区
- 你可以给参数设置默认值

# 格式化
![[Pasted image 20221120102308.png]]

```go
func TestFormat(t *testing.T) {
	now := time.Now()

	format := now.Format("2006/01/02 15:04:05")
	format1 := now.Format("2006/01/02 03:04:05") // 12 小时制
	fmt.Printf("time format %v\n", format)
	fmt.Printf("time format 12 %v\n", format1)
}

```

# 时间间隔
- duration

![[Pasted image 20221120102945.png]]

![[Pasted image 20221120103505.png]]

默认是 UTC 时间，如果不是 UTC 时间，会默认找本地的时区 Asia/Shanghai

# 其他计算

![[Pasted image 20221120103758.png]]

![[Pasted image 20221120103806.png]]


# Tricker
- Ticker是一个周期触发定时的计时器，它会按照一个时间间隔往channel发送系统当前时间，而channel的接收者可以以固定的时间间隔从channel中读取事件。

![[Pasted image 20221120104550.png]]

![[Pasted image 20221120105156.png]]

- timer 只执行一次，再后面的项目中再继续学习把。

![[Pasted image 20221120110620.png]]
![[Pasted image 20221120110747.png]]
![[Pasted image 20221120110813.png]]

- reset timer

![[Pasted image 20221120110830.png]]
![[Pasted image 20221120110851.png]]


# Reference
- time.NewTricker