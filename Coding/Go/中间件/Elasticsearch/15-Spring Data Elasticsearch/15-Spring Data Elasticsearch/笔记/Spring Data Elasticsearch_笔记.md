# Spring Data Elasticsearch

#### 是什么

Spring Data 的目的是用统一的接口，适配所有不同的存储类型。

Spring Data Elasticsearch是Spring Data的一个子项目，该项目旨在为新数据存储提供熟悉且一致的基于 Spring 的编程模型，同时保留特定于存储的功能和功能。Spring Data Elasticsearch是一个以 POJO 为中心的模型，用于与 Elastichsearch 文档交互并轻松编写 Repository 风格的数据访问层

#### 特点

- Spring 配置支持使用基于 Java 的`@Configuration`类或用于 ES 客户端实例的 XML 命名空间。
- `ElasticsearchTemplate`提高执行常见 ES 操作的生产力的助手类。包括文档和 POJO 之间的集成对象映射。
- 功能丰富的对象映射与 Spring 的转换服务集成
- 基于注释的映射元数据但可扩展以支持其他元数据格式
- `Repository`接口的自动实现，包括对自定义查找器方法的支持。
- 对存储库的 CDI 支持

#### 官网

https://spring.io/projects/spring-data-elasticsearch

#### 兼容性(必看)

https://docs.spring.io/spring-data/elasticsearch/docs/4.2.1/reference/html/#preface.requirements

#### 文档地址

https://docs.spring.io/spring-data/elasticsearch/docs/4.2.1/reference/html/#reference

#### 优缺点

- 优点：用统一的接口，适配所有不同的存储类型，学习成本低。
- 缺点：适配的版本要比原生的 API 要慢。这个取决于 Spring Data Elasticsearch 团队的开发速度。无法使用ES的一些新特性

#### Maven Repository

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
</dependency>
```

#### 注解

```java
@Document：在类级别应用，以指示该类是映射到数据库的候选类。最重要的属性包括：

indexName：用于存储此实体的索引的名称。它可以包含类似于“日志-#{T（java.time.LocalDate）.now（）.toString（）}”

type :映射类型。如果未设置，则使用该类的小写简单名称。（自4.0版起已弃用）

createIndex：标记是否在存储库引导时创建索引。默认值为true。请参阅自动创建带有相应映射的索引

versionType：版本管理的配置。默认值为外部 .

@Id：在字段级别应用，以标记用于标识的字段。

@Transient：默认情况下，存储或检索文档时，所有字段都映射到文档，此批注不包括该字段。

@PersistenceConstructor：标记在从数据库实例化对象时要使用的给定构造函数（甚至是包受保护的构造函数）。构造函数参数按名称映射到检索文档中的键值。

@Field：应用于字段级别并定义字段的属性，大多数属性映射到相应的Elasticsearch映射定义（以下列表不完整，请查看注释Javadoc以获取完整的参考）：

name：将在Elasticsearch文档中表示的字段的名称，如果未设置，则使用Java字段名称。

type：字段类型，可以是Text，关键字，Long，Integer，Short，Byte，Double，Float，Half_Float，Scaled_Float，日期，日期Nanos，Boolean，Binary，Integer_Range，Float_Range，Long_Range，DoubleˉRange，DateˉRange，Object，Nested，Ip，TokenCount，percollator，flatten，搜索。请参阅Elasticsearch映射类型

format：一个或多个内置日期格式，请参阅下一节格式数据映射 .

pattern：一个或多个自定义日期格式，请参阅下一节格式数据映射 .

store：标志是否应将原始字段值存储在Elasticsearch中，默认值为假 .

analyzer ,搜索分析器 ,normalizer用于指定自定义分析器和规格化器。

@GeoPoint：将字段标记为地理点如果字段是GeoPoint班级
```

#### 操作类型

Spring Data Elasticsearch 使用多个接口来定义可以针对 Elasticsearch 索引调用的操作。

- `IndexOperations`定义索引级别的操作，例如创建或删除索引。
- `DocumentOperations`定义基于 id 存储、更新和检索实体的操作。
- `SearchOperations`定义使用查询搜索多个实体的操作
- `ElasticsearchOperations`结合了`DocumentOperations`和`SearchOperations`接口。

#### High Level REST Client

```java
@Configuration
public class RestClientConfig extends AbstractElasticsearchConfiguration {

    @Override
    @Bean
    public RestHighLevelClient elasticsearchClient() {

        final ClientConfiguration clientConfiguration = ClientConfiguration.builder()  
            .connectedTo("localhost:9200")
            .build();

        return RestClients.create(clientConfiguration).rest();                         
    }
}

@Autowired
RestHighLevelClient highLevelClient;
RestClient lowLevelClient = highLevelClient.lowLevelClient();                        


IndexRequest request = new IndexRequest("spring-data")
  .id(randomID())
  .source(singletonMap("feature", "high-level-rest-client"))
  .setRefreshPolicy(IMMEDIATE);

IndexResponse response = highLevelClient.index(request,RequestOptions.DEFAULT); 
```

