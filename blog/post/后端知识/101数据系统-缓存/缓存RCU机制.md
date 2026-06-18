在很多缓存架构中，有旧值兜底的策略
- linux的RCU（Read  copy update），对共享数据结构， 先生成新版本，在切换指针，旧版本按需要回收
	- 如路由表， 调度器数据， 内核对象引用
- Guava/Caffine等缓存设计中，都有refreshAfterWrite的设计