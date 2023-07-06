## Docker 安装

- [elasticsearch - Official Image | Docker Hub](https://hub.docker.com/_/elasticsearch)

RESTful 资源状态转换，HTTP 就满足了 REST 风格。不应该包含对文件的操作，相同的接口对资源访问。GET, POST, PUT, DELETE, HEAD。

GET HEAD 的操作时安全的。幂等性，得到的结果时相同的。

ES 返回 JSON 格式

postman 下载

面向文档的 NoSQL 数据库

![[Snipaste/Pasted image 20221025110026.png]]

- 索引为了优化查询，索引时搜索引擎的关键。

倒排索引

- keyword --- id
- name 1001, 1002
- 通过关键字查询逐渐 ID，以前是逐渐 ID 查内容、
- 类型的概念没有了

正排索引/正向索引

- 模糊查询效果差了很多
- **模糊匹配怎么说？**
- docker compose up -d

## 基本使用

Index 创建索引等同于创建数据库  
![[Snipaste/Pasted image 20221025110717.png]]

- 确实可以通过 go 去操作，就是 put 操作云云。
- post 是没有幂等性的，允许 GET PUT HEAD DELETE
- GET http://localhost:9200/shopping
- 显示所有索引  
![[Snipaste/Pasted image 20221025111013.png]]

- 直接在索引中添加数据
- http://localhost:9200/shopping/_doc

![[Snipaste/Pasted image 20221025111356.png]]

- 添加文档的时候使用 POST
- 因为 \_id 是随机生成的，所以只能用 POST，不能用 PUT，因为 PUT 只能是幂等性的。  
![[Snipaste/Pasted image 20221025111616.png]]
- \_create
- 主键查询： GET http://127.0.0.1:9200/shopping/_doc/1001
- 全查询：GET http://127.0.0.1:9200/shopping/_search
- 全量修改：POST http://127.0.0.1:9200/shopping/_doc/1

```json
{
    "title":"华为手机",
    "category":"华为",
    "images":"http://www.gulixueyuan.com/hw.jpg",
    "price":1999.00
}
```

- "result": "updated",//<-----------updated 表示数据被更新
- 局部修改: POST  http://127.0.0.1:9200/shopping/\_update/1
- 删除: DELETE http://127.0.0.1:9200/shopping/_doc/1

倒排索引的分词技术，所以查询部分关键字 (如“米”) 也能搜索到数据。全文检索

- 小华也会被分词，搜索的更多了。
- match 模糊匹配
- match_phrase

### 通配符

```python
from elasticsearch import Elasticsearch, helpers
es = Elasticsearch([{'host': 'xx.xx.xx.xx', 'port': 1234}], timeout=30)

body = {
        "query": {
            "bool": {
                "filter": [
                    {
                      "range": {
                          "ts": {
                              "gte": '2019-11-01 00:00:00',
                              "lt": '2019-11-29 00:00:00'
                          }
                      },
                    }
                ],
                'must': [
                    {'match_phrase': {'source': 'baidu'}},
                    {'wildcard': {'title': '*青南*'}}
                ],
                "must_not": [
                     {'wildcard': {'title': {'value': '*大神*'}}}
                ],
            }
        },
        }
res = es.search(index='spider_data', body=body)
print(res)
```

### 范围查询

### 分页查询

- 深度分页查询
- 前端滚动向下的方式

数据量少于 top 10000 的时候，使用 from + size 的方式查询，大于 top 10000 使用 search after 的方式。

#### From + Size

```shell
POST user_index/_search
{
    "from": 0, 
    "size": 10,
    "query": {
        "match_all": {}
    },
    "sort": [
        {"id": "asc"}    
    ]
}
```

- 有上限

```shell
POST user_index/_search
{
    "from": 10000, 
    "size": 10,
    "query": {
        "match_all": {}
    },
    "sort": [
        {"id": "asc"}    
    ]
}

```

- 返回

```json
"root_cause": [
      {
        "type": "illegal_argument_exception",
        "reason": "Result window is too large, from + size must be less than or equal to: [10000] but was [10001]. See the scroll api for a more efficient way to request large data sets. This limit can be set by changing the [index.max_result_window] index level setting."
      }
    ],
    "type": "search_phase_execution_exception",

```

- 暂时缓解

```shell
PUT user_index/_settings
{ 
    "index" : { 
        "max_result_window" : 20000
    }
}
```

不推荐使用 from + size 做深度分页查询的核心原因：

- 搜索请求通常跨越多个分片，每个分片必须将其请求的命中内容以及任何先前页面的命中内容加载到内存中。
- 对于翻页较深的页面或大量结果，这些操作会显著增加内存和 CPU 使用率，从而导致性能下降或节点故障。

#### Search after

#### Scroll

- 不再使用

### Search Tricks

- [(91条消息) 你必须知道的23个最有用的Elasticseaerch检索技巧_hellozhxy的博客-CSDN博客](https://blog.csdn.net/hellozhxy/article/details/81480829?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166881598916782414950176%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166881598916782414950176&biz_id=0&spm=1018.2226.3001.4187)

## 集群的部署

### Windows

- /config/elasticsearch.yml
- cluster.name : my-application
- node. name : node-1001
- network.host: localhost
- http.port: 9201
- transport.tcp.port: 9301 数据传输通信端口
- node.master: true
- node.data: true
- http.cors.enables: true
- http.cors.allow-origin: "\*"
- 处理跨访问
- 集群状态查询
- delete data and logs
- Node
	- node.name
	- http.port
	- transport.tcp.port
- 节点当成一个整体

![[Snipaste/Pasted image 20221029171127.png]]

- 注意是内部通信端口
- discovery.seed_hosts: ["localhost: 9301"]
- discovery.zen.fd.ping_timeout: 1m
- discovery.zen.fd.ping_retries: 5
- 后启动的查找前面的。
- discovery.seed_hosts: ["localhost: 9301", "localhost:9302"]
- 注意是内部端口
- http://localhost:1001/_cluster/health
- node1

```yml
#节点 1 的配置信息：
#集群名称，节点之间要保持一致
cluster.name: my-elasticsearch
#节点名称，集群内要唯一
node.name: node-1001
node.master: true
node.data: true
#ip 地址
network.host: localhost
#http 端口
http.port: 1001
#tcp 监听端口
transport.tcp.port: 9301
#discovery.seed_hosts: ["localhost:9301", "localhost:9302","localhost:9303"]
#discovery.zen.fd.ping_timeout: 1m
#discovery.zen.fd.ping_retries: 5
#集群内的可以被选为主节点的节点列表
#cluster.initial_master_nodes: ["node-1", "node-2","node-3"]
#跨域配置
#action.destructive_requires_name: true
http.cors.enabled: true
http.cors.allow-origin: "*"

```

node2

```yml
#节点 2 的配置信息：
#集群名称，节点之间要保持一致
cluster.name: my-elasticsearch
#节点名称，集群内要唯一
node.name: node-1002
node.master: true
node.data: true
#ip 地址
network.host: localhost
#http 端口
http.port: 1002
#tcp 监听端口
transport.tcp.port: 9302
discovery.seed_hosts: ["localhost:9301"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
#集群内的可以被选为主节点的节点列表
#cluster.initial_master_nodes: ["node-1", "node-2","node-3"]
#跨域配置
#action.destructive_requires_name: true
http.cors.enabled: true
http.cors.allow-origin: "*"

```

- node3

```yml
#节点 3 的配置信息：
#集群名称，节点之间要保持一致
cluster.name: my-elasticsearch
#节点名称，集群内要唯一
node.name: node-1003
node.master: true
node.data: true
#ip 地址
network.host: localhost
#http 端口
http.port: 1003
#tcp 监听端口
transport.tcp.port: 9303
#候选主节点的地址，在开启服务后可以被选为主节点
discovery.seed_hosts: ["localhost:9301", "localhost:9302"]
discovery.zen.fd.ping_timeout: 1m
discovery.zen.fd.ping_retries: 5
#集群内的可以被选为主节点的节点列表
#cluster.initial_master_nodes: ["node-1", "node-2","node-3"]
#跨域配置
#action.destructive_requires_name: true
http.cors.enabled: true
http.cors.allow-origin: "*"
```

### Linux

- 创建新用户
- useradd es
- passwd es

需要修改一些系统的配置，因为 ES 产生的数据量是比较多的。

![[Snipaste/Pasted image 20221029173500.png]]

- Linux 运行 ES 的时候会动态生成一些文件夹，但是这些文件夹的权限不是 es 用户的，所以用回到 root 用户下赋予 es 用户权限。

## 进阶

### 核心概念

- 提高搜索的性能
- 万物皆索引
- 不再支持类型
- 保存了一个数据就是保存了一个文档 \_doc
- 分表，可以理解为 MySQL 中的分表，数据太多了。数据库的垂直分表。
	- 允许水平切割/扩展容量
	- 允许分布式查询，提高吞吐量
		- 负载均衡
- 副本 replicas 高可用性，吞吐量
- 分配 master 数据和 master 是没有关系的。
- 副本不能和源文件放在同一个服务上

### 系统架构

![[Snipaste/Pasted image 20221101103110.png]]

### 分布式集群

#### 单节点集群

#### 多节点

- 一个节点被选举成为主节点时， 它将负责管理集群范围内的所有变更

## Kibana

![[Snipaste/Pasted image 20221101112816.png]]  
![[Snipaste/Pasted image 20221101113248.png]]

- 需要下载压缩包。下午测试完 API 之后就去把环境搭建好吧 。
- [开始使用Kibana_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1KC4y1p7KR/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)

## Beats

- 付费的部分，大数据的分析，高级别安全。
- security
- 规则告警，私有云的管理平台

## ELK on K8s

- 传统架构包含几个组件
	- Filebeats：通过 Filebeats 去采集日志文件。
	- Kafka
	- Logstash
	- Elasticsearch
	- Kibana

![[Snipaste/Pasted image 20221028221711.png]]

- 将不同的组件部署在不同的 pod 中
- 集群有唯一的表示，默认是 elasticsearch
- Node：一台服务器一般放一个节点

## Reference

- [Notebook](https://blog.csdn.net/u011863024/article/details/115721328)
- [【尚硅谷】ElasticSearch教程入门到精通（基于ELK技术栈elasticsearch 7.x+8.x新特性）_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1hh411D7sb/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [elastic/go-elasticsearch: The official Go client for Elasticsearch (github.com)](https://github.com/elastic/go-elasticsearch)
- [免费且开放的搜索：Elasticsearch、ELK 和 Kibana 的开发者 | Elastic](https://www.elastic.co/cn/)
- [Java API](https://blog.csdn.net/weixin_43823808/article/details/119930308)
- [Opensearch API](https://opensearch.org/docs/latest/clients/java-rest-high-level/)
- [(90条消息) 17个有用的elasticsearch查询_小兜全糖(cxc)的博客-CSDN博客_elasticsearch 查询](https://blog.csdn.net/weixin_43632687/article/details/125651064?ops_request_misc=&request_id=&biz_id=102&spm=1018.2226.3001.4187)
- [【IT老齐163】基于Java与ElasticSearch7实现多条件复合查询_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1BT4y1B75V/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
- [范围 | Elasticsearch: 权威指南 | Elastic](https://www.elastic.co/guide/cn/elasticsearch/guide/current/_ranges.html)——这是重要的资料
- [format | Elasticsearch Guide [master] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/master/mapping-date-format.html)
- [(91条消息) ES深度分页查询详解_斗者_2013的博客-CSDN博客](https://blog.csdn.net/w1014074794/article/details/119389765?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166881522016800215052826%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166881522016800215052826&biz_id=0&spm=1018.2226.3001.4187)
- [(91条消息) 你必须知道的23个最有用的Elasticseaerch检索技巧_hellozhxy的博客-CSDN博客](https://blog.csdn.net/hellozhxy/article/details/81480829?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166881598916782414950176%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166881598916782414950176&biz_id=0&spm=1018.2226.3001.4187)
- [Get请求如何正确的传递数组 - 掘金 (juejin.cn)](https://juejin.cn/post/7087073910243459079)
- [是否使elasticsearch只返回某些字段？ - 问答 - 腾讯云开发者社区-腾讯云 (tencent.com)](https://cloud.tencent.com/developer/ask/sof/59255)
