# 输出
![[Pasted image 20221117105552.png]]

## 占位符
![[Pasted image 20221117105651.png]]

![[Pasted image 20221117105831.png]]

![[Pasted image 20221117105901.png]]

- 注意单引号

![[Pasted image 20221117105953.png]]

![[Pasted image 20221117110055.png]]

![[Pasted image 20221117110221.png]]

-  宽度标识符

![[Pasted image 20221117112000.png]]

![[Pasted image 20221117112018.png]]
- 右对齐

![[Pasted image 20221117113104.png]]

## Fprintf
![[Pasted image 20221117113644.png]]
![[Pasted image 20221117113711.png]]

![[Pasted image 20221117113748.png]]

![[Pasted image 20221117113858.png]]

- 像浏览器输出。io.Writer 的方法
- Sprintf 非常好用

![[Pasted image 20221117145338.png]]

![[Pasted image 20221117145405.png]]

![[Pasted image 20221117145445.png]]

## fmt.Scan
![[Pasted image 20221117145523.png]]

![[Pasted image 20221117145818.png]]

![[Pasted image 20221117145956.png]]

# os
- os 包提供了操作系统函数，但和操作系统无关
- os 包的接口规定为在所有操作系统都是一致的
- 设计为 Unix 风格
- perm uint

![[Pasted image 20221117185431.png]]

![[Pasted image 20221117193659.png]]

linux 命令: rz

![[Pasted image 20221117194011.png]]

```go
package std_test

import (
	"fmt"
	"os"
	"testing"
)

func TestCrete(t *testing.T) {
	file, err := os.Create("test.txt")

	pe := err.(*os.PathError)
	if pe != nil {
		t.Fatal(pe)
	}

	defer func(file *os.File) {
		err := file.Close()
		if err != nil {
			fmt.Println(err)
		}
	}(file)
}

func TestMakeDir(t *testing.T) {
	err := os.Mkdir("test", os.ModePerm)
	if err != nil {
		t.Fatal(err)
	}
}

func TestMakeDirAll(t *testing.T) {
	err := os.MkdirAll("a/b/c", os.ModePerm)
	if err != nil {
		t.Fatal(err)
	}
}

func TestRemove(t *testing.T) {
	err := os.RemoveAll("a")
	if err != nil {
		t.Fatal(err)
	}
}

func TestWorkPlace(t *testing.T) {
	dir, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	fmt.Println(dir)
}

func TestRename(t *testing.T) {
	err := os.Rename("test", "test_1")
	if err != nil {
		t.Fatal(err)
	}
}

func TestChmod(t *testing.T) {
	file, err := os.Create("test_file")
	if err != nil {
		t.Fatal(err)
	}
	defer func(file *os.File) {
		err := file.Close()
		if err != nil {
			t.Fatal(err)
		}
	}(file)

	err = os.Chmod("test_file", os.ModePerm)
	if err != nil {
		t.Fatal(err)
	}
}

```

## 文件
![[Pasted image 20221117201216.png]]

![[Pasted image 20221117201259.png]]

### Read
```go
// file
func TestReadFile(t *testing.T) {
	file, err := os.OpenFile("test_file", os.O_RDWR|os.O_CREATE, 0755)
	if err != nil {
		t.Fatal(err)
	}
	defer func(file *os.File) {
		err := file.Close()
		if err != nil {
			t.Fatal(err)
		}
	}(file)

	var body []byte
	for {
		bytes := make([]byte, 10)
		n, err := file.Read(bytes)
		if err == io.EOF {
			break
		}
		body = append(body, bytes[:n]...)
	}
	fmt.Println(string(body))
}

func TestReadAt(t *testing.T) {
	file, err := os.OpenFile("test_file", os.O_RDWR|os.O_CREATE, 0755)
	if err != nil {
		t.Fatal(err)
	}
	defer func(file *os.File) {
		err := file.Close()
		if err != nil {
			t.Fatal(err)
		}
	}(file)

	// 网络协议用处非常大
	buf := make([]byte, 5)

	n, _ := file.ReadAt(buf, 5)
	fmt.Println(string(buf[:n]))
}

func TestReadDir(t *testing.T) {
	dir, err := os.Open("test_1")
	if err != nil {
		t.Fatal(err)
	}

	defer func(dir *os.File) {
		err := dir.Close()
		if err != nil {
			panic(err)
		}
	}(dir)

	// dirs.for 快接近
	readDir, err := dir.ReadDir(-1)
	if err != nil {
		t.Fatal(err)
	}

	for _, v := range readDir {
		fmt.Println(v.Name(), ":", v.IsDir())
	}
}

```
### Write

![[Pasted image 20221117203439.png]]


![[Pasted image 20221117203528.png]]

- 注意 Linux 编译操作

## 进程相关

![[Pasted image 20221117203804.png]]

![[Pasted image 20221117204529.png]]
![[Pasted image 20221117204642.png]]
- d:\\test.txt

![[Pasted image 20221117204712.png]]

![[Pasted image 20221117204814.png]]

## Signal
![[Pasted image 20221117204945.png]]
![[Pasted image 20221117205012.png]]

![[Pasted image 20221117211446.png]]

![[Pasted image 20221117211538.png]]

- 中断信号
- 开启多个阻塞操作

![[Pasted image 20221117211743.png]]

- 去错误里面比对

![[Pasted image 20221117211804.png]]

- Args 参数

## 环境相关

![[Pasted image 20221117212137.png]]

- 只在当前环境有效

![[Pasted image 20221117212445.png]]


# time



# log

# error

# bytes

# io

# ioutil

# bufio

# builtin

# json

# sort

# math

# flag

# runtime

# context


# Reference
- [【go标准库】02-格式化占位符_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Rd4y1K75i/?p=2&spm_id_from=pageDriver&vd_source=25509bb582bc4a25d86d871d5cdffca3)
