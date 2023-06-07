作者：uuspider  
链接：https://www.zhihu.com/question/23374078/answer/65352538  
来源：知乎  
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。  

举一个例子：It's [知乎日报](https://www.zhihu.com/search?q=%E7%9F%A5%E4%B9%8E%E6%97%A5%E6%8A%A5&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D)

你看到的 [unicode字符集](https://www.zhihu.com/search?q=unicode%E5%AD%97%E7%AC%A6%E9%9B%86&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D) 是这样的编码表：

```text
I 0049
t 0074
' 0027
s 0073
  0020
知 77e5
乎 4e4e
日 65e5
报 62a5
```

每一个字符对应一个 [十六进制数字](https://www.zhihu.com/search?q=%E5%8D%81%E5%85%AD%E8%BF%9B%E5%88%B6%E6%95%B0%E5%AD%97&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D)。

计算机只懂二进制，因此，严格按照 unicode 的方式 (UCS-2)，应该这样存储：

```text
I 00000000 01001001
t 00000000 01110100
' 00000000 00100111
s 00000000 01110011
  00000000 00100000
知 01110111 11100101
乎 01001110 01001110
日 01100101 11100101
报 01100010 10100101
```

这个字符串总共占用了 18 个字节，但是对比中英文的 [二进制码](https://www.zhihu.com/search?q=%E4%BA%8C%E8%BF%9B%E5%88%B6%E7%A0%81&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D)，可以发现，英文前 9 位都是 0！浪费啊，浪费硬盘，浪费流量。

怎么办？

UTF。

UTF-8 是这样做的：

1. [单字节](https://www.zhihu.com/search?q=%E5%8D%95%E5%AD%97%E8%8A%82&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D) 的字符，字节的第一位设为 0，对于英语文本，[UTF-8码](https://www.zhihu.com/search?q=UTF-8%E7%A0%81&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D) 只占用一个字节，和 ASCII 码完全相同；
2. n 个字节的字符 (n>1)，第一个字节的前 n 位设为 1，第 n+1 位设为 0，后面字节的前两位都设为 10，这 n 个字节的其余空位填充该 [字符unicode码](https://www.zhihu.com/search?q=%E5%AD%97%E7%AC%A6unicode%E7%A0%81&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D)，高位用 0 补足。

这样就形成了如下的 [UTF-8标记位](https://www.zhihu.com/search?q=UTF-8%E6%A0%87%E8%AE%B0%E4%BD%8D&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D)：

```text
0xxxxxxx

110xxxxx 10xxxxxx

1110xxxx 10xxxxxx 10xxxxxx

11110xxx 10xxxxxx 10xxxxxx 10xxxxxx

111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx

1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx

```

于是，”It's 知乎日报“就变成了：

```text
I 01001001
t 01110100
' 00100111
s 01110011
  00100000
知 11100111 10011111 10100101
乎 11100100 10111001 10001110
日 11100110 10010111 10100101
报 11100110 10001010 10100101
```

和上边的方案对比一下，英文短了，每个中文字符却多用了一个字节。但是整个字符串只用了 17 个字节，比上边的 18 个短了一点点。

下边是课后作业：

请将”It's 知乎日报“的 GB2312 和 GBK 码 (自行 google) 转成二进制。不考虑历史因素，从技术角度解释为什么在 unicode 和 [UTF-8](https://www.zhihu.com/search?q=UTF-8&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A65352538%7D) 大行其道的同时，GB2312 和 GBK 仍在广泛使用。

剧透：一切都是为了节省你的硬盘和流量。

## Reference

- [(17 封私信 / 81 条消息) Unicode 和 UTF-8 有什么区别？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/23374078)
