Canal 是一个基于 MySQL 数据库增量日志解析的开源项目，用于实现数据库的增量数据同步，可以将 MySQL 数据库的变化实时同步到其他数据库、搜索引擎或者其他存储系统中。Canal 主要用于解决数据库与其他系统的数据一致性问题，广泛应用于数据仓库同步、搜索引擎同步等场景。

## 基本配置

Canal 的配置文件主要位于 `conf` 目录下的 `instance.properties` 文件中。以下是一些基本配置项的介绍：

- **canal.instance.mysql.address**：MySQL 服务器地址。
- **canal.instance.mysql.port**：MySQL 服务端口。
- **canal.instance.mysql.user**：Canal 连接 MySQL 时使用的用户名。
- **canal.instance.mysql.password**：连接 MySQL 的密码。
- **canal.instance.dbUsername**：Canal 连接到目标数据库时使用的用户名，可与 `canal.instance.mysql.user` 相同。
- **canal.instance.dbPassword**：连接到目标数据库的密码，可与 `canal.instance.mysql.password` 相同。
- **canal.instance.connectionCharset**：MySQL 的字符集设置，默认为 UTF-8。
- **canal.instance.defaultDatabaseName**：默认监听的数据库名，可以为空，为空则监听所有数据库的变更。
- **canal.instance.filter.regex**：过滤规则表达式，用于指定需要订阅的表的正则表达式，默认为 `.*\\..*` 订阅所有数据库和表。

## 使用

1. **启动 Canal 服务**：

   首先，确保已经正确安装并配置好 Canal，然后可以通过以下命令启动 Canal 服务：

   ```bash
   sh bin/startup.sh
   ```

2. **配置 MySQL**：

   为了让 Canal 能够监控 MySQL 的变化，需要开启 MySQL 的 binlog 日志并设置为 `ROW` 模式：

   ```sql
   [mysqld]
   log-bin=mysql-bin
   binlog-format=ROW
   server-id=1
   ```

   确保 Canal 使用的 MySQL 用户有权限读取 binlog。

3. **客户端订阅**：

   开发客户端应用订阅 Canal 服务，处理数据变更事件。Canal 客户端连接到 Canal 服务端后，根据配置的数据库和表的过滤规则，接收数据库的变化数据。

   下面是一个简单的 Java 客户端订阅示例：

   ```java
   CanalConnector connector = CanalConnectors.newSingleConnector(new InetSocketAddress(Address,
           Port), "example", "", "");
   connector.connect();
   connector.subscribe(".*\\..*");
   connector.rollback();
   while (true) {
       Message message = connector.getWithoutAck(100); // 获取指定数量的数据
       long batchId = message.getId();
       int size = message.getEntries().size();
       if (batchId == -1 || size == 0) {
           // 没有获取到数据，休眠一会儿
           Thread.sleep(1000);
       } else {
           // 处理数据
           handleEntries(message.getEntries());
       }
       connector.ack(batchId); // 确认已成功消费
   }
   ```

4. **处理数据**：

   在客户端，解析从 Canal 服务端接收到的数据。根据 binlog 中的事件类型（如 INSERT、UPDATE、DELETE），对应用中的数据进行同步或其他业务逻辑处理。

Canal 的配置和使用相对直接，但要注意确保 MySQL 的配置与 Canal 的配置相匹配，以及在实际部署和使用过程中要考虑高可用性和故障转移策略。

---

在 Go 语言中监听并处理 Canal 数据，通常涉及以下几个步骤：

1. **使用 Canal 部署并配置 MySQL**：确保你已经按照前面的指南配置好了 Canal 和 MySQL，Canal 正在运行并且能够接收到 MySQL 的 binlog 日志。
2. **选择或编写 Go 语言的 Canal 客户端库**：虽然 Canal 官方主要提供 Java 客户端，但社区有一些 Go 语言实现的客户端库，如 `github.com/CanalClient/canal-go`。你可以选择这些现成的库，或者根据 Canal 的协议自行实现客户端。
3. **编写 Go 程序监听 Canal**：使用选定的 Go 客户端库连接到 Canal 服务，订阅感兴趣的数据库或表的变更，然后实现数据变更的处理逻辑。

下面是一个简单的示例，展示如何使用 `canal-go` 客户端库在 Go 中监听并处理 Canal 数据：

首先，确保安装了 `canal-go` 客户端库：

```bash
go get github.com/CanalClient/canal-go
```

然后，编写 Go 程序：

```go
package main

import (
    "context"
    "fmt"
    "github.com/CanalClient/canal-go/client"
    "github.com/CanalClient/canal-go/protocol"
    "time"
)

func main() {
    // 创建 Canal 客户端
    conn, err := client.NewSimpleCanalConnector("127.0.0.1", 11111, "", "", "example", 60*60, 60*60*3)
    if err != nil {
        fmt.Println("Canal 连接失败：", err)
        return
    }
    defer conn.DisConnection()

    // 连接到 Canal
    err = conn.Connect()
    if err != nil {
        fmt.Println("连接 Canal 失败：", err)
        return
    }

    // 订阅数据库表
    err = conn.Subscribe(".*\\..*") // 订阅所有数据库和表
    if err != nil {
        fmt.Println("订阅 Canal 数据失败：", err)
        return
    }

    for {
        message, err := conn.Get(100, nil, nil)
        if err != nil {
            fmt.Println("获取数据失败：", err)
            time.Sleep(time.Second * 5)
            continue
        }

        if len(message.Entries) == 0 {
            time.Sleep(time.Second * 1)
            continue
        }

        for _, entry := range message.Entries {
            // 只处理 ROWDATA 类型的数据
            if entry.EntryType == protocol.EntryType_ROWDATA {
                rowChange := new(protocol.RowChange)
                err = rowChange.Unmarshal(entry.StoreValue)
                if err != nil {
                    fmt.Println("反序列化失败：", err)
                    continue
                }

                // 处理数据变更
                fmt.Printf("表名：%s，操作类型：%s\n", entry.Header.TableName, rowChange.EventType)
                for _, rowData := range rowChange.RowDatas {
                    if rowChange.EventType == protocol.EventType_DELETE {
                        printColumn(rowData.BeforeColumns)
                    } else {
                        printColumn(rowData.AfterColumns)
                    }
                }
            }
        }
    }
}

func printColumn(columns []*protocol.Column) {
    for _, col := range columns {
        fmt.Println(col.Name, ": ", col.Value)
    }
}
```

这个示例程序创建了一个 Canal 客户端，连接到 Canal 服务，订阅所有数据库和表的变更，并打印出变更的表名、操作类型以及具体的列数据。

请注意，这只是一个基本的示例，实际使用时可能需要根据业务逻辑对数据进行更复杂的处理。此外，也需要考虑异常处理、重连逻辑等稳定性和可靠性相关的措施。
