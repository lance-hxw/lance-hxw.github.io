long范围是64位， int是32位
# 数组

# 集合
## map
遍历：
- for(Map.Entry<K,V> entry: map.entrySet())
- for(K key: map.keySet()){}
	- 对value同理
put: 覆盖旧的
get:
merge(K, V, BiFunction),如：
- merge(key, value2, (value_old, value_new) -> value_old+valude_new)
	- 就是加，如果原来不存在，就是直接put，忽略bifunction
	- 如果存在，加
entrySet
keySet
valueSet
getOrDefault

computeIfAbsent:指定的key不存在，就用新值，否则返回这个value
computeIfPresent：如果存在，就基于这个值计算新值，否则不操作

## List
add,remove,get,set(),size()
## ArrayList
只实现了List的功能
！！！注意，如果你提前设定capacity，也只是设定了底层数组大小，size还是0
## LinkedList,下面这些是实现了Deque的接口
会抛异常
addFirst，removeFirst
addLast， removeLast
getFirst，getLast
isEmpty

## queue，使用LinkedList就行
三套接口：
- offer， poll，peek： 不抛出异常，非阻塞， 返回特殊值
	- 这个最常用
- add， remove， element：抛出异常，非阻塞
- （阻塞队列BlockingQueue）put， take
	- 用于通讯
# Math
min
max
abs

