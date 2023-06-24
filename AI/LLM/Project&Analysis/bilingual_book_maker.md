
- Time：2023-06-24 19:11
- Label： #github #chatgpt

## Abstract

1. python 代理的写法
2. epub 的处理过程

## Content

利用 chatgpt 进行翻译

- Please help me to translate,`{text}` to {self.language}, please return only translated content not include the origin text  

代码可以这样写

```python
    PROXY = options.proxy
    if PROXY != "":
        os.environ["http_proxy"] = PROXY
        os.environ["https_proxy"] = PROXY
```

- 这里面还有关于 epub 处理的代码  

总结：似乎没有什么可以借鉴的东西，鉴定为只是时间问题。

## Reference

- https://github.com/yihong0618/bilingual_book_maker
