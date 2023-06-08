- `protoc --go_out=./blog ./blog/*.proto`

![[Snipaste/Pasted image 20220922124352.png]]

- 文件要以 protobuf 结尾

![[Snipaste/Pasted image 20220922125953.png]]  
![[Snipaste/Pasted image 20220922172348.png]]

- 分配唯一编号

## 如何定义消息类型

![[Snipaste/Pasted image 20220922172505.png]]

- 其实用 1~15 就足够了哦

### 指定字段规则

![[Snipaste/Pasted image 20220922172622.png]]

### 保留字段

![[Snipaste/Pasted image 20220922172715.png]]

### 编译器将会生成什么？

![[Snipaste/Pasted image 20220922172804.png]]

## Protocol Buffer 里面的基数据类型

- 记住常用的就行了

## 枚举类型

![[Snipaste/Pasted image 20220922173119.png]]

- enum
- 大写
- 从 0 开始
- 定义字段编号

![[Snipaste/Pasted image 20220922173221.png]]

- 允许别名

![[Snipaste/Pasted image 20220922173435.png]]

## Go 源码分析

- go mod tidy 可以安装依赖
- User 结构体
- tag 标签
- Reset
- String 返回字符串类型的描述
- ProtoMessage 返回当前的用户
- ProtoReflect 反射机制对应一个 Message 对象，与 JSON 相互转化
- GetUID 初始化结构体，获取属性
- 根据不同的属性进行自动生成

## 序列化与反序列化

```go
func main() {  
   user := &person.Person{Name: "ZhangSan", Age: 12, Email: "zhangsan1999@163.com"}  
   bytes, _ := proto.Marshal(user)  
   fmt.Println(bytes)  
  
   anotherPerson := &person.Person{}  
   proto.Unmarshal(bytes, anotherPerson)  
   fmt.Println(anotherPerson.Name)  
   fmt.Println(anotherPerson.Age)  
   fmt.Println(anotherPerson.Email)  
}
```

## 与 JSON 之间相互转化

```go
user_json := protojson.Format(user.ProtoReflect().Interface())  
fmt.Println(user_json)  
  
msg := user.ProtoReflect().Interface()  
protojson.Unmarshal([]byte(user_json), msg)  
fmt.Println(msg)
```

## 在 Protobuf 中定义服务

![[Snipaste/Pasted image 20220922222618.png]]

- RPC

![[Snipaste/Pasted image 20220922222714.png]]

```go
service userService{  
  rpc login(Person) returns(Person);  
  rpc register(Person)returns(Person);  
}
```

- 接下来的内容和 gRPC 有关哦

## Reference

- [Protocol Buffers(protobuf) 必须学、必须会、必须这样学](https://www.bilibili.com/video/BV1Y3411j7EM/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
