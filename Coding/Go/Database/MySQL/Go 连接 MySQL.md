- Time：2023-07-10 13:44
- Label： #go #mysql #chatgpt

## Abstract

简要介绍如何利用 Go 连接 MySQL 服务器

## Content

在 Go 语言中，你可以使用第三方的 MySQL 驱动程序来连接 MySQL 服务器。目前，比较常用的 MySQL 驱动程序是 `go-sql-driver/mysql`。

首先，你需要在你的 Go 项目中引入 `go-sql-driver/mysql` 包。你可以使用以下命令来安装它：

```
go get -u github.com/go-sql-driver/mysql
```

安装完成后，你可以使用下面的代码来连接 MySQL 服务器：

```go
package main

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	// 创建数据库连接
	db, err := sql.Open("mysql", "user:password@tcp(host:port)/database")
	if err != nil {
		fmt.Println("连接数据库失败:", err)
		return
	}
	defer db.Close()

	// 测试连接是否成功
	err = db.Ping()
	if err != nil {
		fmt.Println("连接测试失败:", err)
		return
	}

	fmt.Println("成功连接到MySQL服务器！")
}
```

上面的代码中，你需要替换 `user`、`password`、`host`、`port` 和 `database` 为你的实际 MySQL 服务器的连接信息。如果连接成功，将会输出 " 成功连接到 MySQL 服务器！"。

注意，在实际应用中，你可能还需要处理数据库查询、事务等操作。你可以使用 `db.Query()`、`db.Exec()` 等方法来执行 SQL 查询和更新操作。

希望对你有所帮助！如有更多问题，请随时提问。

## Reference
