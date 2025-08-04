
# 写写隔离

都是基于锁实现的 

其隔离级别

- RR:
	- 使用next-key lock解决了幻读问题
		- 类似物化, 但是用一整个间隙作为实体上锁, 比较灵活, 但是可能死锁
	- 可以使用FOR UPDATE 解决write skew
	- 不是SI, 是基于锁的实现方式
	- 实际相当于可串行化
		- 但不是真的可串行化, 有边界场景的异常  

## RU
理论上RU是不允许脏写, 允许脏读, 但是Innodb使用MVCC, 可以直接避免脏读, 相当于RC
具体实现上, 不生成read view, 但走mvcc解决读冲突 

## RC
理论上RC是不允许脏读即可
innodb中, 在每次select的时候, 构造一个新的readview, 使用undolog追溯, 获取最新的已提交版本 

## RR
基于MVCC实现了可重复读, 在开始的时候建立一个read view
写冲突基于冲突检测进行
在带范围的for update中, 额外使用next key 解决幻读问题
