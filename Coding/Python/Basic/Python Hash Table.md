- Time：2023-07-09 13:03
- Label： #python #哈希表 #chatgpt

## Abstract

1. 创建
2. 添加
3. 访问
4. 检查是否存在
5. 删除
6. 遍历

## Content

在 Python 中，哈希表可以使用字典（dictionary）数据结构来表示和使用。字典是一种无序的键值对集合，其中每个键都是唯一的。以下是使用哈希表的一些基本操作示例：

1. 创建一个空的哈希表：

   ```python
   my_dict = {}
   ```

2. 添加键值对到哈希表中：

   ```python
   my_dict["key1"] = "value1"
   my_dict["key2"] = "value2"
   ```

3. 访问哈希表中的值：

   ```python
   print(my_dict["key1"])  # 输出：value1
   ```

4. 检查键是否存在于哈希表中：

   ```python
   if "key1" in my_dict:
       print("Key found!")
   ```

5. 删除哈希表中的键值对：

   ```python
   del my_dict["key2"]
   ```

6. 遍历哈希表中的键值对：

   ```python
   for key, value in my_dict.items():
       print(key, value)
   ```

请注意，Python 的字典是一种动态数据结构，可以根据需要自由添加、修改和删除键值对。这使得字典非常适合用作哈希表。

## Reference

