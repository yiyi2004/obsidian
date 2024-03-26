50min，感觉在聊天算法 + 八股

1. 自我介绍
2. python 和 java 有什么区别？python 和 java 在性能层面分别适用什么场景
3. sql 里面的 group by 语句是做什么的
4. sql 的性能优化方式
5. 数据库里说的最左匹配是什么
6. SQL 语句里面使用 like 需要注意些什么
	1. 性能考虑
	2. 大小写敏感，可以使用 Lower() 函数
	3. 转移字符
		1. 当需要在模式中匹配% 或 _ 本身时，需要使用转义字符。不同的数据库系统可能有不同的转义机制。例如，在 SQL Server 中，可以使用 ESCAPE 子句指定转义字符：WHERE column LIKE '%25!%%' ESCAPE '!' 将匹配以 "25%" 结尾的字符串。%%
	4. 避免 SQL 注入——参数化查询、或者数据库框架提供安全构建查询。
7. 进程的调度算法
8. 算法两个：二叉树的右视图 + 二叉树转链表，都问了实现方法的时间复杂度
9. 你为什么投我们这个岗，你知道 Devops 是在做什么的吗？可以更具体的说一下 Devops 有什么优势以及你为什么会想要从事这个方向呢？你现在在实习的这个公司你有用过相关平台吗，体验如何，有什么想法？
10. 我看你本科还学过计算机图形学，这个学了什么
11. Docker 和 kubernetes 都了解吗？（我说我只了解 docker 但是 kubernetes 只是用过所以后面都问的 docker）
12. docker 的原理？cgroup 了解吗？命名空间呢？docker 是如何做到内存隔离的？cgroup 和命名空间的关系是什么

作者：卿辰棠  
链接：[https://www.nowcoder.com/discuss/519243628863029248?sourceSSR=users](https://www.nowcoder.com/discuss/519243628863029248?sourceSSR=users)  
来源：牛客网
