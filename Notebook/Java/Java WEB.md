# Navicat

![[Pasted image 20220929234717.png]]
- 数据库的技术暂时不是痕迹s

# Maven
![[Pasted image 20220915214332.png]]
![[Pasted image 20220915214456.png]]
- 标准化构建流程

![[Pasted image 20220915214742.png]]

![[Pasted image 20220915214923.png]]
![[Pasted image 20220915215511.png]]
- 本地仓库
- 中央仓库
- 远程仓库：私服
![[Pasted image 20220915215755.png]]

## Maven 简介
![[Pasted image 20220929235440.png]]

- 依赖查询：mysql maven
- alt + isnert ---> ctrl + i

# Mybatis

## Mapper 代理开发
- [(82条消息) IntelliJ IDEA 设置代码提示或自动补全的快捷键 (附IntelliJ IDEA常用快捷键)_a13145213710的博客-CSDN博客](https://blog.csdn.net/a13145213710/article/details/101599677?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166722808016782429721272%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166722808016782429721272&biz_id=0&spm=1018.2226.3001.4187)

![[Pasted image 20221103111217.png]]
- 上面还存在硬编码的问题，UserMapper 是 interface，里面的方法对应于配置文件中的 id。
- 不依赖于字面值，更安全，代码补全。
- 最为常见的开发方法。

![[Pasted image 20221103111440.png]]

- 直接拖进去，但是不推荐，配置文件放在 Resources 中
- package 会分层，Directory 要注意。

- 目录结构。
![[Pasted image 20221103125249.png]]

- 创建 Directory 要用 / 做分隔符  

## 核心配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>  
<!DOCTYPE configuration  
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"  
        "https://mybatis.org/dtd/mybatis-3-config.dtd">  
<configuration>  
    <environments default="development">  
        <environment id="development">  
            <transactionManager type="JDBC"/>  
            <dataSource type="POOLED">  
<!--                连接信息-->  
                <property name="driver" value="com.mysql.jdbc.Driver"/>  
<!--                这里报错的原因是什么捏？-->  
                <property name="url" value="jdbc:mysql:///mybatis?useSSL=false"/>  
                <property name="username" value="root"/>  
                <property name="password" value="123456"/>  
            </dataSource>  
        </environment>  
    </environments>  
    <mappers>  
<!--        加载 SQL 的映射文件-->  
        <mapper resource="com/itheima/mapper/UserMapper.xml"/>  
<!--        这里是导入 mapper 的地方-->  
        <package name="com.itheima.mapper"/>  
    </mappers>  
</configuration>
```

- environment
- 事务的管理方式，这个信息可以用 Spring 来操作，这个操作由 Spring 接管。
- 数据源的信息也会被 Spring 接管

![[Pasted image 20221103131556.png]]
- resultType 自定义别名

![[Pasted image 20221103131709.png]]
- 通过包扫描的方式，不区分大小写。

![[Pasted image 20221103131753.png]]
- 用别名的方式简化配置，
- 默认的别名
- 配置各个标签的时候要注意配置的前后关系。

## 配置文件完成增删改查
- 配置文件 CRUD
- 注解 CRUD
- 动态 SQL

![[Pasted image 20221105111222.png]]
- 业务基本模块

- 准备环境
	- 数据库表 tb_brand
	- 实体类 Brand
	- 测试用例
	- 安装 MyBatisX 插件

- 红色头绳、蓝色头绳，自动补全。
- 自动补全、自动生成 sql id 等等

- 使用别名解决映射错误问题，但其实是从 mysql 角度解决的。
```xml
<select id="selectAll" resultType="brand">
    select
    id, brand_name as brandName, company_name as companyName, ordered, description, status
    from tb_brand;
</select>
```

![[Pasted image 20221105113718.png]]

```xml
 <resultMap id="brandResultMap" type="brand">
     <!--
            id：完成主键字段的映射
                column：表的列名
                property：实体类的属性名
            result：完成一般字段的映射
                column：表的列名
                property：实体类的属性名
        -->
     <result column="brand_name" property="brandName"/>
     <result column="company_name" property="companyName"/>
</resultMap>



<select id="selectAll" resultMap="brandResultMap">
    select *
    from tb_brand;
</select>
```

![[Pasted image 20221105220058.png]]

- #{} 不存在 SQL 注入问题
- ${} 会拼接 SQL 语句，从而导致 SQL 注入问题。

- 特殊字段处理

![[Pasted image 20221105220803.png]]

- 编写多参数接口的方法

![[Pasted image 20221105221105.png]]
- @Param(“status”)
- 封装到类里面
- Map ---> #{}

```xml
<select id="selectByCondition" resultMap="brandResultMap">
    select *
    from tb_brand
    where status = #{status}
    and company_name like #{companyName}
    and brand_name like #{brandName}
</select>
```
- 注意是 resultMap 不是 resultType
- 因为是多个参数

```java
@Test

public void testSelectByCondition() throws IOException {
    //接收参数
    int status = 1;
    String companyName = "华为";
    String brandName = "华为";

// 处理参数
    companyName = "%" + companyName + "%";
    brandName = "%" + brandName + "%";

//1. 获取SqlSessionFactory

    String resource = "mybatis-config.xml";

    InputStream inputStream = Resources.getResourceAsStream(resource);

    SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);

    //2. 获取SqlSession对象

    SqlSession sqlSession = sqlSessionFactory.openSession();

    //3. 获取Mapper接口的代理对象

    BrandMapper brandMapper = sqlSession.getMapper(BrandMapper.class);

​

    //4. 执行方法

    //方式一 ：接口方法参数使用 @Param 方式调用的方法

    //List<Brand> brands = brandMapper.selectByCondition(status, companyName, brandName);

    //方式二 ：接口方法参数是 实体类对象 方式调用的方法

     //封装对象

    /* Brand brand = new Brand();

        brand.setStatus(status);

        brand.setCompanyName(companyName);

        brand.setBrandName(brandName);*/

    //List<Brand> brands = brandMapper.selectByCondition(brand);

    //方式三 ：接口方法参数是 map集合对象 方式调用的方法

    Map map = new HashMap();

    map.put("status" , status);

    map.put("companyName", companyName);

    map.put("brandName" , brandName);

    List<Brand> brands = brandMapper.selectByCondition(map);

    System.out.println(brands);

​

    //5. 释放资源

    sqlSession.close();

}
```

- 动态 SQL，这个功能我很喜欢，golang 能实现动态 SQL 嘛？
- if
- choose (when, otherwise)
- trim (where, set)
- foreach

```xml
<select id="selectByCondition" resultMap="brandResultMap">
    select *
    from tb_brand
    where
        <if test="status != null">
            and status = #{status}
        </if>
        <if test="companyName != null and companyName != '' ">
            and company_name like #{companyName}
        </if>
        <if test="brandName != null and brandName != '' ">
            and brand_name like #{brandName}
        </if>
</select>
```

- [Java 动态 SQL](https://blog.csdn.net/m0_52008932/article/details/123646530?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166786947316782388013264%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166786947316782388013264&biz_id=0&spm=1018.2226.3001.4187)

![[Pasted image 20221108090645.png]]


![[Pasted image 20221108090952.png]]

- 优化 open, close
- collection map params
- item
- separator

## Mybatis 参数传递

![[Pasted image 20221108091132.png]]
- 参数传递
- Collection is  HashSet
- 可以通过断点调试的方式进入函数，看源码不错的方式。

## 注解实现 CURD
* 查询 ：@Select
* 添加 ：@Insert
* 修改 ：@Update
* 删除 ：@Delete

# Web 核心
- HTTP Tomcat Servlet
- Request Response
- JSP Cookie Session
- Filter Listener
- Ajax Vue ElementUI
- 综合案例

## Tomcat
- 安装 tomcat

### 自定义 Server
- 你这样的创建方式也太费劲了，不如用别人封装好的。

```java
package com.itheima;

import sun.misc.IOUtils;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
/*
    自定义服务器
 */
public class Server {
    public static void main(String[] args) throws IOException {
        ServerSocket ss = new ServerSocket(8080); // 监听指定端口
        System.out.println("server is running...");
        while (true){
            Socket sock = ss.accept();
            System.out.println("connected from " + sock.getRemoteSocketAddress());
            Thread t = new Handler(sock);
            t.start();
        }
    }
}

class Handler extends Thread {
    Socket sock;

    public Handler(Socket sock) {
        this.sock = sock;
    }

    public void run() {
        try (InputStream input = this.sock.getInputStream()) {
            try (OutputStream output = this.sock.getOutputStream()) {
                handle(input, output);
            }
        } catch (Exception e) {
            try {
                this.sock.close();
            } catch (IOException ioe) {
            }
            System.out.println("client disconnected.");
        }
    }

    private void handle(InputStream input, OutputStream output) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(input, StandardCharsets.UTF_8));
        BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(output, StandardCharsets.UTF_8));
        // 读取HTTP请求:
        boolean requestOk = false;
        String first = reader.readLine();
        if (first.startsWith("GET / HTTP/1.")) {
            requestOk = true;
        }
        for (;;) {
            String header = reader.readLine();
            if (header.isEmpty()) { // 读取到空行时, HTTP Header读取完毕
                break;
            }
            System.out.println(header);
        }
        System.out.println(requestOk ? "Response OK" : "Response Error");
        if (!requestOk) {
            // 发送错误响应:
            writer.write("HTTP/1.0 404 Not Found\r\n");
            writer.write("Content-Length: 0\r\n");
            writer.write("\r\n");
            writer.flush();
        } else {
            // 发送成功响应:

            //读取html文件，转换为字符串
            BufferedReader br = new BufferedReader(new FileReader("http/html/a.html"));
            StringBuilder data = new StringBuilder();
            String line = null;
            while ((line = br.readLine()) != null){
                data.append(line);
            }
            br.close();
            int length = data.toString().getBytes(StandardCharsets.UTF_8).length;

            writer.write("HTTP/1.1 200 OK\r\n");
            writer.write("Connection: keep-alive\r\n");
            writer.write("Content-Type: text/html\r\n");
            writer.write("Content-Length: " + length + "\r\n");
            writer.write("\r\n"); // 空行标识Header和Body的分隔
            writer.write(data.toString());
            writer.flush();
        }
    }
}
```
- 自定义 Server，这段代码没有什么难点。其实人的大脑和计算机有很大的相似性。
- 修改端口，借助 IDEA 打包成 war 包，tomcat 会自动解压缩。

### Web 项目结构
![[Pasted image 20221108124029.png]]
![[Pasted image 20221108124130.png]]
  
- 开发项目通过执行Maven打包命令==package==,可以获取到部署的Web项目目录
- 编译后的Java字节码文件和resources的资源文件，会被放到WEB-INF下的classes目录下
- pom.xml中依赖坐标对应的jar包，会被放入WEB-INF下的lib目录下

上面部分还需要看一下源代码才能理解。

- 骨架创建 maven
- archifect id 是什么
- ctrl + shift + s ---> create from 骨架

- 使用骨架
![[Pasted image 20221109101005.png]]
- 不适用骨架
![[Pasted image 20221109101128.png]]

### 配置 tomcat
- 项目右上角 add configuration

![[Pasted image 20221109101738.png]]

![[Pasted image 20221109101750.png]]

- maven  插件使用 tomcat

```xml
<build>
    <plugins>
    	<!--Tomcat插件 -->
        <plugin>
            <groupId>org.apache.tomcat.maven</groupId>
            <artifactId>tomcat7-maven-plugin</artifactId>
            <version>2.2</version>
            <configuration>
            	<port>80</port><!--访问端口号 -->
                <!--项目访问路径
					未配置访问路径: http://localhost:80/tomcat-demo2/a.html
					配置/后访问路径: http://localhost:80/a.html
					如果配置成 /hello,访问路径会变成什么?
						答案: http://localhost:80/hello/a.html
				-->
                <path>/</path>
            </configuration>
        </plugin>
    </plugins>
</build>
```
- 插件只支持 tomcat7

## Servlet
> 动态 Web 资源开发技术，Servlet 是 JavaWeb 最为核心的内容。

- 简介
- 快速入门
- 执行流程
- 生命周期
- 方法介绍
- 体系结构
- urlPattern 配置
- XML 配置

### 快速入门
1.  创建Web项目`web-demo`，导入Servlet依赖坐标
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.1.0</version>
    <!--
      此处为什么需要添加该标签?
      provided指的是在编译和测试过程中有效,最后生成的war包时不会加入
       因为Tomcat的lib目录中已经有servlet-api这个jar包，如果在生成war包的时候生效就会和Tomcat中的jar包冲突，导致报错
    -->
    <scope>provided</scope>
</dependency>
```


## Request & Response
### Request

### Response

## MVC 模式和三层架构

## Cookie 和 Session
![[Pasted image 20221109110806.png]]

- 购物车 cookie
- 登录信息 session
- 记住密码 cookie

 