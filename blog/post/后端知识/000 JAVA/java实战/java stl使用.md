# PriorityQueue：不允许offe null进去，会导致比较函数崩溃
api：
- offer
- poll
- peek
- size
- isEmpty
使用：
```java
PriorityQueue<Integer> pq = new PriorityQueue<>();
// 默认最小堆
pq = newPriorityQueue<>(Comparator.reverseOrder());
// 最大了
```
## comparator怎么自定义：
原型为int compare（T o1， T o2）
返回<0: o1\<o2
返回0:相等
返回正数：o1>o2
即O1为主体的大小关系

# Deque （LinkedList/ ArrayDeque）
arrayDeque是基于循环数组的，所以作为queue没有什么性能问题
- 如果需要在中间插入，就需要linked了
- 还有如果需要随机访问，或者需要频繁变化大小（涉及扩容
其中主要api是：
- addFirst/offerFirst（Last
- removeFirst/pollFirst（Last
- getFirst/peekFirst（Last
- push，pop

```java
Deque<Integer> deque = new ArrayDeque<>();
Deque<Integer> linkedDeque = new LinkedList<>()
```