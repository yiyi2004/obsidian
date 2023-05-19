## 相对路径转换为绝对路径

在 Go 中，可以使用 `path/filepath` 包中的 `Abs()` 函数将相对路径转换为绝对路径。以下是一个示例：

```go
package main

import (
	"log"
	"path/filepath"
)

func main() {
	relativePath := "path/to/file.txt"
	absolutePath, err := filepath.Abs(relativePath)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Absolute path:", absolutePath)
}
```

在上述示例中，我们使用 `filepath.Abs()` 函数将相对路径 `"path/to/file.txt"` 转换为绝对路径。`Abs()` 函数接受一个相对或绝对路径作为参数，并返回该路径的绝对路径。如果转换过程中出现错误，如无法解析路径等，可以通过检查返回的错误值来进行错误处理。

运行上述代码，你将得到相对路径转换后的绝对路径的输出。

需要注意的是，相对路径的解析是基于当前工作目录进行的。因此，在获取绝对路径之前，可以使用 `os.Chdir()` 函数来更改当前工作目录，以确保相对路径的解析与预期一致。

希望这个示例对你有帮助！如需进一步了解更多关于 `path/filepath` 包的函数和用法，请参考官方文档：https://golang.org/pkg/path/filepath/
#chatgpt

```go
	dir, _ := os.Getwd()
	os.Chdir(dir)
	relativePath := "./models/ArcFace"
	abs, _ := filepath.Abs(relativePath)
	fmt.Println(abs)

	var cfg Config
	err := json.Unmarshal(config, &cfg)
	if err != nil {
		fmt.Println(err)
	}
```

## Test


### Test 

### test2

##### 123123