- Time：2023-06-15 14:49
- Label： #go #coding #hash #standare-repository

## Abstract

- 简要介绍 strings 字符串处理的标准库
- 文件的处理在任何语言中都是非常重要的，但是我还是喜欢用 Python 去处理捏

## Content

- 从路径中获取文件名，文件后缀等等信息

```go
func GetInfoFromFilePath(fp string) (fileExt string, fileName string, fileNameWithoutExt string) {
	// 获取文件后缀
	fileExt = filepath.Ext(fp)

	// 获取文件基本名称（不包括路径）
	fileName = filepath.Base(fp)

	// 获取文件名（不包括后缀）
	fileNameWithoutExt = fileName[:len(fileName)-len(fileExt)]
	return
}
```

- 用 Go 重命名文件

```go
package main

import (
	"fmt"
	"os"
)

func main() {
	oldName := "/path/to/oldfile.txt"
	newName := "/path/to/newfile.txt"

	err := os.Rename(oldName, newName)
	if err != nil {
		fmt.Println("重命名文件失败:", err)
		return
	}

	fmt.Println("文件重命名成功")
}

```

## Reference
