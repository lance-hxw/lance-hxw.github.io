java 的每个对象都有一个monitor，当使用synchronized的时候会在字节码中进行monitor enter和monitor exit，即获取和释放锁的操作。 这些操作是JVM的ObjectMonitor对象实现的， 存储在线程和对象的元数据结构中。

锁升级过程的操作：
enter：
- 取出markword，查看锁状态
	- 如果是无锁， 就CAS变成轻量级锁， 
		- 在当前线程栈中创建一个Lock Record
		- 将MarkWord拷贝到LockRecord中
		- 使用CAS尝试将对象MarkWord改成当前线程的lockrecord的地址 + 轻量级锁标志位
	- 如果是轻量级锁，就尝试CAS，若多次失败，就升级为重量级锁
		- 分配或者复用一个ObjectMonitor
		- 将对象头MarkWord 替换成指向monitor的指针 + 膨胀标志（重量级锁）
		- 将当前线程加入该monitor的_cxq（Contention queue)
	- 如果是重量级锁
		- 如果owner是null， 说明无人有锁， 直接CAS称为owner
		- 如果owner指向当前线程， 说明可重入，重入次数++
		- 如果是其他线程：
			- 将当前线程加入cxq
			- 若自旋失败，阻塞挂起
exit:
- 若为轻量级锁，取出lockrecord，CAS尝试恢复MarkWord
- 重量级锁：
	- 确定当前线程是owner
	- 递归计数处理重入
	- 完全释放时， 清空owner，然后从cxq 或者entrylist中选一个线程 唤醒
	- 释放内存屏障，保证这些改动对其他线程可见

# monitor 的hotspot实现

结构为：
- owener
- recursions，可重入次数
- EntryList， 等待获取锁的线程队列 
- cxq， 新竞争队列
- WaitSet， 调用wait的线程队列

cxq是LIFO的，后来线程在前面， 更方便CAS，但没公平性

线程在monitor的等待过程：
- owner是当前持有者
- EntryList是等待唤醒的线程，是实际锁抢占区
- cxq是新来的竞争者， 是入口等待
- WaitSet是自己wait的线程，是主动放弃锁的， 是在调用notify的时候才会发生的

状态变化：
- 当释放锁的时候
	- cxq的全部线程都会被转移到EntryList 的尾部，是先反转再append在后面，不是直接出栈
	- 然后尝试唤醒EntryList前面的一个或者多个线程
- notify（all）的时候
	- 将一定的waitset中的元素放到entryList的前面，参与后续竞争
	- 注意，notify是放前面

