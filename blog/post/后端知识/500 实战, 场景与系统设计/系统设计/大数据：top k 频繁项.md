寻找最频繁的k个数（heavy hitters）


# 精确算法
- hashmap+heap
	- map存所有元素出现个数
	- 小顶堆heap存放k个元素
	- 写：先改map，再去heap查，如果存就就修改+调整，否则比较堆顶，再调整
- 分片+hashmap+heap
	- 最终多个heap归并一下就行了
# 近似算法
- count-min sketch + heap
	- count-min sketch可以作为map的近似替代，就是多次hash
- Lossy counting
	- 一个hash map
	- 一个窗口，数据不断进去，窗口满了就统计频率，结束后所有频率减1，然后将0次的从map中删掉

