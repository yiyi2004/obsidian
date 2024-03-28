## 1. 用 Fmt 包实现简单数字读取

## 2. 必须整行读

```go
func main() {
    inputs := bufio.NewScanner(os.Stdin)
    for inputs.Scan() {  //每次读入一行
        data := strings.Split(inputs.Text(), " ")  //通过空格将他们分割，并存入一个字符串切片
        var sum int
        for i := range data {
            val, _ := strconv.Atoi(data[i])   //将字符串转换为int
            sum += val
        }
        fmt.Println(sum)
    }
}
```

## 3. 读字符串

```go
func main(){
    in := bufio.NewScanner(os.Stdin)
    in.Scan()
    for in.Scan(){
        str := in.Text()
        s := strings.Split(str, " ")
        sort.Strings(s)  //排序
        fmt.Println(strings.Join(s," "))  //将切片连接成字符串
    }
}
```

- [【Go】用 Golong 处理 ACM 模式下的输入输出_golang输入输出acm-CSDN博客](https://blog.csdn.net/weixin_44211968/article/details/124632136)

---

## Go-ACM 模式刷题常用函数和注意事项

由于个人能力有限，部分描述若不正确，感谢指出！暂时记录这些，期待更新！

### 一、终端输入相关函数和注意事项

```go
var a,b,x int
fmt.Scan(&a,&b) // 一个或多个数据绑定。用空格分割stdin输入数据，并把换行符算作空格，然后传递给本函数的参数
fmt.Scanln(&a,&b) // 类似Scan，遇到换行停止扫描，必须在最后一项之后有换行符或EOF
fmt.Scanf("%d",&x) // 对空格分割的字符串或其他数据类型格式化，会把换行符也当作输入的！由于数据是先缓存，然后再传递给参数，所以如果格式中没有换行符，但输入回车换行，会保存到下一个参数中！
```

还有一些细节，比如输入类型和指定类型不符合时, 值为类型的默认值！多编程多动手体会自己写的 bug！

个人体会，少用 fmt.Scanf()，不会分析，很容易跳到坑里，比如为啥输入参数绑定不对！很可能是回车换行符导致的！

### 二、字符串的处理

```go
// strconv包，字符串和其他类型的相互转换
strconv.Itoa(int)  // int -> string
strconv.Atoi(str)  // string -> int

strconv.ParseInt(str, , ) // str->int 可以指定进制、类型.还有float\bool等
strconv.FormatInt(int, , ) // int->str。还有其他float等函数
```

```go
// strings包，字符串的查找
strings.IndexByte(str, byte) // 查找字符串中字符的第一个位置。LastIndexByte是最后一个
strings.Index(str,str2)  // 查找子串str2的第一个位置

// 字符串分割
strings.Splie(str, str2) // 将str按str2作为分隔符进行分割，返回字符串切片

// 大小写切换
strings.ToLower(str) // string全部转为小写
strings.ToUppe(str)  // str全部转为大写

// 字符串删除
strings.Trim(str, str2) // 将str中首位包含的str2全部删除

```

```go
// 强制类型转换
x := []rune(str)  // 字符串转rune切片
str := string(x)  // rune切片转为字符串

```

#### 三、排序

```go
// 升序
sort.Ints([]int) // 对int类型的切片升序排序
sort.Float64s([]float64)
sort.Strings([]int)

sort.Reverse() // 进行反转
```
