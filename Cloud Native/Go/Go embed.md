对嵌入静态文件的需求，方便go程序的迁移和部署

```go
package main
import (
    "embed"
    "fmt"
)

//go:embed p
var f embed.FS
func main() {
    data, _ := f.ReadFile("p/hello.txt")
    fmt.Println(string(data))
    data, _ = f.ReadFile("p/hello2.txt")
    fmt.Println(string(data))
}
```

尝试将深度学习模型的代码嵌入进去

## [[Reference]] 
- [Golang1.16 使用embed加载静态文件 | Go 技术论坛 (learnku.com)](https://learnku.com/articles/60054)