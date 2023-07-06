# ES客户端：Elasticsearch Clients

## 语言无关性

- **Java REST Client**
- **Java API**
- **Python API**
- **Go API**
- **.Net API**
- PHP API
- JavaScripts API
- Ruby API
- Perl API
- Eland
- Rust
- Community Contributed Clients

## Java API

#### 生命周期（生卒年：ES 0.9 - ES 7.x）

`Java API`使用的客户端名称叫`TransportClient`，从7.0.0开始，官方已经不建议使用`TransportClient`作为ES的Java客户端了，并且从8.0会被彻底删除。

#### 注意事项

- `TransportClient` 使用`transport`模块（**9300端口**）远程连接到 Elasticsearch 集群，客户端并不加入集群，而是通过获取单个或者多个transport地址来以轮询的方式与他们通信。
- `TransportClient`使用`transport`协议与Elasticsearch节点通信，如果客户端的版本和与其通信的ES实例的版本不同，就会出现兼容性问题。而`low-level REST`使用的是HTTP协议，可以与任意版本ES集群通信。`high-level REST`是基于`low-level REST`的。

#### Maven依赖

```xml
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>transport</artifactId>
    <version>7.12.1</version>
</dependency>
```

#### 使用

```java
// 创建客户端连接
TransportClient client = new PreBuiltTransportClient(Settings.EMPTY)
        .addTransportAddress(new TransportAddress(InetAddress.getByName("host1"), 9300))
        .addTransportAddress(new TransportAddress(InetAddress.getByName("host2"), 9300));

// 关闭客户端
client.close();
```

#### 嗅探器

```java
Settings settings = Settings.builder()
        .put("client.transport.sniff", true).build();
TransportClient client = new PreBuiltTransportClient(settings);
```

#### 

## Java REST Client

`RestClient` 是线程安全的，`RestClient`使用 Elasticsearch 的 HTTP 服务，默认为`9200`端口，这一点和`transport client`不同。

#### 生命周期（ES 5.0.0-alpha4至今）

#### Java Low-level REST client

第一个 5.0.0 版 Java REST 客户端，之所以称为低级客户端，是因为它几乎没有帮助 Java 用户构建请求或解析响应。它处理请求的路径和查询字符串构造，但它将 JSON 请求和响应主体视为必须由用户处理的不透明字节数组。

##### 特点

- 与任何 Elasticsearch 版本兼容
  - ES 5.0.0只是发布第一个`Java Low-level REST client`时的ES版本（2016年），不代表其向前只兼容到5.0，`Java Low-level REST client`基于Apache HTTP 客户端，它允许使用 HTTP 与任何版本的 Elasticsearch 集群进行通信。
- 最小化依赖
- 跨所有可用节点的负载平衡
- 在节点故障和特定响应代码的情况下进行故障转移
- 连接失败惩罚（是否重试失败的节点取决于它连续失败的次数；失败的尝试越多，客户端在再次尝试同一节点之前等待的时间就越长）
- 持久连接
- 请求和响应的跟踪记录
- 可选的集群节点自动发现（也称为嗅探）

##### Maven依赖

```xml
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>elasticsearch-rest-client</artifactId>
    <version>7.12.0</version>
</dependency>
```

##### 初始化

```java
RestClient restClient = RestClient.builder(
    new HttpHost("localhost1", 9200, "http"),
    new HttpHost("localhost2", 9200, "http")).build();
```

##### 资源释放

```java
restClient.close();
```



##### 嗅探器

允许从正在运行的 Elasticsearch 集群中自动发现节点并将它们设置为现有 RestClient 实例的最小库

###### Maven依赖

```
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>elasticsearch-rest-client-sniffer</artifactId>
    <version>7.12.1</version>
</dependency>
```

###### 代码

```java
// 默认每五分钟发现一次
RestClient restClient = RestClient.builder(
    new HttpHost("localhost", 9200, "http"))
    .build();
Sniffer sniffer = Sniffer.builder(restClient).build();
```

###### 资源释放

`Sniffer` 对象应该与`RestClient` 具有相同的生命周期，并在客户端之前关闭。

```java
sniffer.close();
restClient.close();
```

###### 设置嗅探间隔

```java
RestClient restClient = RestClient.builder(
    new HttpHost("localhost", 9200, "http"))
    .build();
// 设置嗅探间隔为60000毫秒
Sniffer sniffer = Sniffer.builder(restClient)
    .setSniffIntervalMillis(60000).build();
```

###### 失败时重启嗅探

启用失败时嗅探，也就是在每次失败后，节点列表会立即更新，而不是在接下来的普通嗅探轮中更新。在这种情况下，首先需要创建一个 SniffOnFailureListener 并在 RestClient 创建时提供。此外，一旦稍后创建嗅探器，它需要与同一个 SniffOnFailureListener 实例相关联，它将在每次失败时收到通知，并使用嗅探器执行额外的嗅探轮

```java
SniffOnFailureListener sniffOnFailureListener =
    new SniffOnFailureListener();
RestClient restClient = RestClient.builder(
    new HttpHost("localhost", 9200))
    .setFailureListener(sniffOnFailureListener) //将失败侦听器设置为 RestClient 实例 
    .build();
Sniffer sniffer = Sniffer.builder(restClient)
    .setSniffAfterFailureDelayMillis(30000) //在嗅探失败时，不仅节点在每次失败后都会更新，而且还会比平常更早安排额外的嗅探轮次，默认情况下是在失败后一分钟，假设事情会恢复正常并且我们想要检测尽快地。可以在 Sniffer 创建时通过 setSniffAfterFailureDelayMillis 方法自定义所述间隔。请注意，如果如上所述未启用故障嗅探，则最后一个配置参数无效。
    .build();
sniffOnFailureListener.setSniffer(sniffer); //将 Sniffer 实例设置为失败侦听器
```



#### Java High Level REST Client

生命周期（ES 5.0.0-alpha4至今）

Java 高级 REST 客户端在 Java 低级 REST 客户端之上运行。它的主要目标是公开 API 特定的方法，接受请求对象作为参数并返回响应对象，以便请求编组和响应解组由客户端本身处理。要求Elasticsearch版本为`2.0`或者更高。

#### 客户端优缺点及兼容性建议

阅读：https://www.elastic.co/cn/blog/benchmarking-rest-client-transport-client

##### Java API

- **优点**：
  - 性能略好：
  - 吞吐量大：`Transport Client`的批量索引吞吐量比HTTP 客户端大 4% 到 7%（实验室条件）
- **缺点**：
  - 重依赖：并非单独意义上的“客户端”，其依赖于lucene、log4j2等，可能会产生依赖冲突
  - 不安全：Java API通过传输层调用服务，不安全。
  - 重耦合：和ES核心服务有共同依赖，版本兼容性要求高。

##### REST API

##### 优点

- 安全：`REST API`使用单一的集群入口点，可以通过 HTTPS 保障数据安全性，传输层只用于内部节点到节点的通信。
- 易用：客户端只通过 REST 层而不是通过传输层调用服务，可以大大简化代码编写

##### 缺点

- 性能略逊于`Java API`，但是差距不大

------

- ##### Low level Client

  - **优点**：
    - 轻依赖：Apache HTTP 异步客户端及其传递依赖项（Apache HTTP 客户端、Apache HTTP Core、Apache HTTP Core NIO、Apache Commons Codec 和 Apache Commons Logging）
    - 兼容性强：兼容所有ES版本
  - **缺点**：
    - 功能少：显而易见，轻量化带来的必然后果

- ##### High level Client
  - **优点**：
    - 功能强大：支持所有ES的API调用。
    - 松耦合：客户端和ES核心服务完全独立，无共同依赖。
    - 接口稳定：REST API 比与 Elasticsearch 版本完全匹配的`Transport Client`接口稳定得多。
  - **缺点**：
    - 兼容性中等：基于Low Level Client，只向后兼容ES的大版本，比如6.0的客户端兼容6.x（即6.0之后的版本），但是6.1的客户端未必支持所有6.0ES的API，但是这并不是什么大问题，咱们使用相同版本的客户端和服务端即可，而且不会带来其他问题。