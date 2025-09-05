java 集合类， 主要包括
接口：
- Collection 顶层接口
- List 有序集合
- Set 不重复元素
- Queue 队列
	- 扩展后为Deque（继承了Queue
- Map （不继承collection）
实现类如
- ArrayList，LinkedList
- HashSet， LinkedHashSet， TreeSet
- HashMap, LinkedHashMap, TreeMap
方法:
- 排序，查找，同步，不可变集合等
# 整体关系

- 单列集合Collection
	- set，list，queue，deque
- 双列集合Map
	- map


# 主要实现关系

LinkedList, 实现Deque和List

TreeSet 实现 NavigableSet
TreeMap实现NavigableMap

# 主要工具类

Collections中：
- sort(list)
- binarySearch(list, key)

# Set 与 Map关系

Set和Map是两个接口
但是Set的实现类一般用map实现

HashSet用一个HashMap存元素， value是固定的虚拟对象
- HashMap的key是不重复的， 所以HashSet自然也不重复

其他的也类似， 可以把Set看成Map的退化版

# null key

hashTable 和TreeMap不支持
concurrentHashMap也不支持