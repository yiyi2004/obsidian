- ES 入门
	- 基本概念
		- 索引
		- 文档
		- 分片
		- 复制
- ES API 入门
	- 创建索引
	- 写入文档
	- 查询文档
		- range
		- term
		- match
		- …
- 搜索服务设计与实现
	- 业务方上报数据
		- 用户索引创建
		- 文章索引创建
	- 业务方搜索接口
- 标签服务设计与实现
	- 需求分析
		- 普通标签
		- 层级标签
	- 标签服务设计与实现
- 利用标签来优化搜索
	- 搜索结果的分数
	- 为搜索条件赋予不同分数  

## ES 入门

ES 简介

![[Snipaste/Pasted image 20240311214112.png]]

1. 基于 Lucene、快速、可靠的存储、检索和分析大量数据
2. 见到高效、帮助开发人员高效快熟构建和部署应用程序
3. 近实时搜索，几秒钟内被索引和搜搜
4. 极大数据量支持，10 甚至上百节点 PB 级数据的存储和检索
5. 灵活的 RESTful API 轻松与各种语言和应用程序集成

- 提供从业务到可观测性等全方面的解决方案
- 依赖两个字：搜索

为什么使用 ES

![[Snipaste/Pasted image 20240311215531.png]]

1. 高性能
2. 近实时
3. 大数据
4. 丰富的功能
5. 灵活的查询和搜索操作
6. 社区支持与生态系统

ES 的基本概念  

![[Snipaste/Pasted image 20240311220736.png]]

- 数据组织方式
	- 索引：数据表
	- 文档：数据
- 数据的部署方式
	- 分片：分库分表
	- 副本：主从同步中的从库

大型中间件类似的机制

- 分片：没办法将数据都放在同一个地方，单节点撑不住
- 副本：没有副本、节点崩溃、数据全没

### 索引和倒排索引

![[Snipaste/Pasted image 20240311221811.png]]

- 索引两个含义
	- 数据表
	- ES 特殊的索引形式，倒排索引
- 正排：找到数据 ---> 属性
- 倒排：属性 ---> 找到这些属性对应的数据

### 倒排索引的组织形式

![[Snipaste/Pasted image 20240311221930.png]]

1. 关键字
2. 排序

### 前缀树与 FST

![[Snipaste/Pasted image 20240311222144.png]]

- FST(Finite State Transducers) 有限状态转换器
	- 前缀共享 + 后缀共享

### 节点和节点类型

![[Snipaste/Pasted image 20240311222425.png]]

1. 候选主节点：主从结构相关
2. 协调节点：协调请求的处理过程，分片相关; 类似于解决分库分表查询的 MySQL 代理
3. 数据节点：存储数据的节点

### 写入流程

- **面试热点中的热点** #面试

![[Snipaste/Pasted image 20240311222645.png]]

- docker 部署

![[Snipaste/Pasted image 20240316103941.png]]

## ES API

ES 数据类型

![[Snipaste/Pasted image 20240316104126.png]]

- keyword 和 text 的区别

![[Snipaste/Pasted image 20240316104504.png]]

1. keyword
	1. 优点
		1. 适用于精确匹配
		2. 支持聚合
		3. 不进行分词
	2. 缺点
		1. 不支持全文搜索
		2. 限制了查询方式：精确 + 范围查询
		3. 可能影响新跟那个
2. text
	1. 优点
		1. 支持全文搜索
		2. 可进行模糊匹配
		3. 支持分析器
	2. 缺点
		1. 不适用于精确匹配
		2. 可能影响性能：数据量大
		3. 需要额外配置：Text 乐星需要配置分析其等参数，相对比较复杂

- ES 查询索引定义

![[Snipaste/Pasted image 20240316104959.png]]

![[Snipaste/Pasted image 20240316105028.png]]

1. 加入 `_doc` 代表操作的文档

![[Snipaste/Pasted image 20240316105124.png]]

1. `_search` + JSON 查询参数

![[Snipaste/Pasted image 20240316105439.png]]

1. ES 支持的查询
	1. Match Query
	2. Term Query
	3. Range Query
	4. Bool Query
	5. Match Phrase Query
	6. Prefix Query
	7. Wildcard Query
	8. Fuzzy Query
	9. Nested Query
	10. Aggregation Query

![[Snipaste/Pasted image 20240316105630.png]]

![[Snipaste/Pasted image 20240316105638.png]]

![[Snipaste/Pasted image 20240316105657.png]]

1. 初始化客户端
2. 整体的架构图要画一下 —— 整体的架构图要找时间画一下

![[Snipaste/Pasted image 20240316105944.png]]

- ES 的 SDK 是真的难用啊！

![[Snipaste/Pasted image 20240316110052.png]]

- 写入文档

![[Snipaste/Pasted image 20240316110121.png]]

1. 搜索文档  

### 面试要点

正常来说，如果你的简历里面没有提到 ElasticSearch 的话，问到你相关内容的概率不是很高。如果问到了，那么在初中级岗位的面试里面，也仅仅是聚焦在 ElasticSearch 的一些基本知识里面。

- 你有没有用过 ElasticSearch？用它来解决什么问题？注意，如果你在实践中没有接触过，可以提自己公司别的部门用它来做什么。
- ElasticSearch 中的倒排索引是什么？为什么叫做倒排索引？
- ElasticSearch 是如何组织倒排索引的？核心是利用了 FST 这个结构
- ElastciSearch 的节点类型有哪些？它们的作用是什么？
- ElasticSearch 的写入过程是怎样的？为什么说它是近实时的？

## 搜索服务设计与实现

![[Snipaste/Pasted image 20240316110628.png]]

1. 方便用户快速查找到所需的内容
2. 增加广告收入
3. 搜索栏本身就是构建信息茧房的一部分

![[Snipaste/Pasted image 20240316111002.png]]

![[Snipaste/Pasted image 20240316111934.png]]

1. 为了支持搜索服务需要将数据同步到 ES 中
	1. 搜索具体的用户
	2. 搜索某篇文章
	3. 评论
2. 需要提供接口，将数据同步过去

![[Snipaste/Pasted image 20240316112111.png]]

1. 研发统一的数据推送接口，统一的接入机制，避免搜索平台本身的修改。

![[Snipaste/Pasted image 20240316112248.png]]

1. 设计通用接口还是针对业务涉及不同的接口
2. 提供不同的接口，编译器的检查，不同业务，都需要提供新的接口
3. JSON 通用接口，遇到紧急的业务，直接通过通用接口接入

![[Snipaste/Pasted image 20240316112838.png]]

1. toA or toB 有些数据的可见性是不一样的
2. nickname 如果是 keyword 有些昵称就很难找到

![[Snipaste/Pasted image 20240316112948.png]]

1. 原生的设计就是垃圾：用 github.com/olivere/elastic/v7

![[Snipaste/Pasted image 20240316113257.png]]

1. insert or update
2. 同一个用户的数据对应同一份文档

![[Snipaste/Pasted image 20240316113412.png]]

1. 帖子如果是不可见状态，不应该被搜索到

![[Snipaste/Pasted image 20240316113531.png]]

1. insert or update 语义

![[Snipaste/Pasted image 20240316113855.png]]

1. 不同业务一般会有定制的搜索接口
2. 设计并实现的是一个全站的模糊搜索
3. SearchRequest 和 SearchResponse  

![[Snipaste/Pasted image 20240316114151.png]]

## 标签服务设计与实现

## 利用标签优化搜索

## 源码阅读

### Tag

### Search
