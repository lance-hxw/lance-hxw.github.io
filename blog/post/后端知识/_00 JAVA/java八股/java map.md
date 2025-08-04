# HashMap 底层实现
其底层数据结构是一个Node\<K,V>的节点数据结构包含了四个成员：
- final int hash
- final K key
- volatile V value
- volatile Node\<K,V> next
插入时，先创建一个node，然后根据hash去找位置，根节点在一个数组上，后续是一个链表或者红黑树
两个volatile禁止指令重排和可见性
# key
map的key可以是任何非空对象，只要实现了hashcode和equals
常见类型有：
- string，integer等包装类
- 自定义且重写了hashcode和equals
- 枚举类型
- 日期，如LocalDate， Date
- 文件， 如file
如果想用可变对象为key，如arraylist，一旦放入后发生了修改，就再也找不到这条数据了（变动后hashcode变了）
treemap要求实现comparable接口或者提供comparator

## 使用数组作为key
此时会对数组hash，所以相同的数组结果可能也不同，此时一般转string进去当key
# 有序map
有对应SortedMap接口，具体实现有TreeMap等
## treemap
- 按键排序的红黑树
- 默认用键类型的自然顺序（comparable），可以自定义comparator
## LinkedHashMap
维护一个链表，保持插入的顺序。
# ConcurrentHashMap
属于java.util.concurrent包，是线程安全的

## 为什么hashmap 线程不安全
没有同步机制
故一个对象会被多个线程同时操作，由于是链式hash表，所以扩容resize时会直接导致位置改变，进而导致程序崩溃。
## ConcurrentHashMap如何保证线程安全
### 1.8前
使用分段锁 segment locking， 将整个表拆成多个segment，每段都是独立的子hash表，访问时按段粒度上锁
### 1.8后
使用CAS和synchronized+volatile，改进了分段锁（锁分离
#### 更细粒度的锁
对bucket级别上锁，达到最小粒度上锁
- 注意，不是单桶上锁，这样锁的数量太大了，还是分段的
#### CAS
无锁并发控制，保证了数据修改是原子的，让其他访问都重试，实现修改无锁
#### synchronized 
只在resize的时候锁住bucket

## 扩容过程
- 条件
	- 元素数量超过阈值(容量x负载因子)
	- 链表超过8且数组超过64就把当前桶变成红黑树, 同时可能触发扩容
- 步骤
	- 创建一个2倍大小的新数组
		- cap是2的幂
	- 迁移元素
		- 多线程协助迁移, 当前线程分配数组,然后将后续迁移任务部分分配给其他线程
		- 标记节点, 原数组节点标记正在迁移或者迁移完成,进行多线程协调
		- 原来元素重新hash写值
	- 替换数组
- 过程中请求：
	- 用特殊标记，标记某个桶是否迁移，如果已经迁移就去新数组

### 过程的安全保证
- CAS 操作, 如创建新数组时, 只有一个线程创建成功
- sychronized, 迁移操作中, 对于链表或者红黑树的操作都是sync的, 比如对链表头加锁,防止修改
- ForwardingNode, 线程协调
## 如何写安全的get/set
在修改时，应该使用concurrentHashMap的compute函数，函数的修改是原子的，实现原理是对这个key对因的bucket上锁
使用方法是，compute(key, (k,v) -> v == null ? 1 : v+1);
或者merge(key, value, (old, new) ->old+new) 也是原子的

# ConcurrentSkipListMap
这是一个线程安全且基于跳表的map实现

# 红黑树优化
当链表过长，默认超过8时，就变成红黑树，这个是hashmap也有的
#### 和treemap区别
treemap是一整颗树


# map.merge 实现原地+
使用map.merge(key, newValue, Integer::sum)
可以将新值和原先的值通过函数合并，如果没有老值，就set。
## 也可以使用getOrDefault(key, defaultValue)
# map.compute
#TODO 

# Tree map
有序， 键不能null， 红黑树，线程不安全
除了SortedMap功能歪，还支持NavigableMap
主要api
- firstEntry
- lastEntry
- lowerKey higher
- floorKey ceiling
- tailMap(K, inclusize),大于（或者等于）的所有key
