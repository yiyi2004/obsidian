```java
@SerializedName("email_address")
public String emailAddress;
```
1. Gson 基本用法
2. 属性重命名 @SerializedName 注解的使用
3. Gson中使用泛型
4. Gson的流式反序列化
5. Gson的流式序列化
6. 使用GsonBuilder导出null值、格式化输出、日期时间

```java
Gson gson = new GsonBuilder().serializeNulls() .create();
User user = new User("张三", 24);
System.out.println(gson.toJson(user)); //{"name":"张三","age":24,"email":null}
```
- json 设置 null 值的方式。

# Reference
- [Java 中 Gson的使用 - 【cosmo】 - 博客园 (cnblogs.com)](https://www.cnblogs.com/qinxu/p/9504412.html)

