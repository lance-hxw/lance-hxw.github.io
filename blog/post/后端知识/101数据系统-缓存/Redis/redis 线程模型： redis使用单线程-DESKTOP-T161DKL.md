# redis 为什么快
- 在内存中
- 使用的是单线程模式，避免线程竞争和切换
- IO多路复用处理大量clientsocket情况
	- 即select epoll机制
	- 一直监听这些socket，需要时让redis线程去处理
# 为什么说redis是单线程的
- 接受客户端请求
- 解析请求
- 进行数据读写
- 发送数据回去
这几个步骤是一个主线程控制的。但是过程中， 会从别的线程取数据
即， 只有一个线程在响应请求， 但是有多个线程执行不同业务
# redis 内部多线程， 主要是BIO机制

主要有三个辅助线程， 与BIO相关
- 关闭文件任务线程
- A O F刷盘任务线程
- 异步释放内存（lazyFree）任务线程
	- 当执行unlink key ， flushdb async， flushall async等删除操作时， 异步进行
	- 即， 当需要删除大key（如大集合）时， 不要用del（这个是主线程处理的）
		- 直接unlink
此外还有三个辅助io线程（默认4io， 主线程算一个）， 共有6线程
## 多线程IO
使用多个IO线程处理数据
在redis6出现， 默认情况下不开启， 需要设置redis.conf中的io-threads-do-reads 设置yes， 还可以设置io线程个数

# IO多路复用
即， 一个线程能同时记录跟踪多个socket状态， 从而处理多个io
其流程为：
- 当一个socket客户端连上来时：
	- 创建一个socket文件描述符
	- 多路复用程序将这个socket对应的文件描述符注册到监听列表（一个队列）中
		- 当客户端执行read/write时， 多路复用程序将其封装成一个时间绑定到该文件描述符上
			- 这样就标记一个socket发起了io请求
	- io线程则通过多路复用程序监控多个文件描述符， 当发生事件， 就回调绑定的事件处理器进行相关操作
以epoll为例
将多个socket的fd注册到epoll， 然后epoll同时监听多个fd， 如果来了数据就通知事件处理器

redis使用reactor设置模式实现


## select， epoll， poll IO多路复用机制对比