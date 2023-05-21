![[Snipaste/Pasted image 20221120205223.png]]

![[Snipaste/Pasted image 20221120205237.png]]

![[Snipaste/Pasted image 20221121152257.png]]
![[Snipaste/Pasted image 20221121152315.png]]
![[Snipaste/Pasted image 20221121152325.png]]

```go
func TestBufferRW(t *testing.T) {
	bufferString := bytes.NewBufferString("Hello, world!")
	b := bufferString.Bytes()
	buf := make([]byte, 6)
	bufferString.Read(buf)

	fmt.Println("bufferString before Read", string(b))
	fmt.Println("bufferString after Read", bufferString)

	bufferString.Write([]byte("Hello, world!!!"))
	fmt.Println("bufferString before Read", string(b))
	fmt.Println("bufferString after Write", bufferString)

	bufferString.Reset()
}

```
![[Snipaste/Pasted image 20221121153226.png]]
![[Snipaste/Pasted image 20221121153410.png]]


# Reader 类型
![[Snipaste/Pasted image 20221121153441.png]]

![[Snipaste/Pasted image 20221121153454.png]]

- Reader 的操作和 Buffer 是类似的。

![[Snipaste/Pasted image 20221121154017.png]]

- 调试的技巧

