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
