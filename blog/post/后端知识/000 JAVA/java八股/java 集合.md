# 线程安全的集合
在util中有：
- vector
- Hashtable: 整表上锁，已经不推荐
在concurrent中
- map 见 [[java map]]
	- ConcurrentHashMap
	- ConcurrentSkipListMap： 可排序
- set
	- ConcurrentSkipListSet： 可排序
	- CopyOnWriteArraySet： 无序， 用动态数组实现
- queue
	- ConcurrentLinkedQ
	- BlockingQ
- deque
	- LinkedBlockingD，没有读写锁分离
	- ConcurrentLinkedD， 
- List：
	- CopyOnWriteArrayList
		- ArrayList的线程安全变体，其中所有写操作都变成直接复制原数组修改并上锁
		- 即：上锁，复制，修改，替换
		- 这个过程中读还是正常的，不会有脏读
Vector，LinkedList和ArrayList都实现了List接口
Vector是早期的线程安全动态数组，其动态每次翻倍
ArrayList动态是增加50%
## 遍历中修改
- 如果用index遍历，只要能保证正确性就行
- 如果在foreach中修改会导致bug，其中的迭代器预期结构与实际结构不同了
- 使用迭代器遍历，可以用迭代器的remove和set
- 线程安全List，并发读写，没有报错，但是可能读到旧的数据（不可重复读）
## 为什么不安全
- null， 如，两个线程同时发现size要满了，还写在了同一个位置，然后扩展了大小。
# PriorityQueue 
线程不安全，如果需要，用concurrent中的
```java
PriorityQueue<Integer> pq = new PriorityQueue<>(Comparator.reverseOrder());
// 大顶堆/默认小顶
pq.offer(E)
pq.poll()
pq.peek()
pq.size()
pq.isEmpty()
```