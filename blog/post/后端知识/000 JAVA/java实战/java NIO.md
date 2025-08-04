# server
- 创建selector
- 创建一个channel，绑定到端口并配置参数
	- 非阻塞
	- 关注事件
		- 这有什么用
- 将channel注册到selector
- 进入loop，使用selector.select等待事件
	- 发生事件后，获取所有发生事件集合
	- 遍历集合将key取出来
	- 判断状态，交给对应handler
		- Acceptable，Read/Write
	- handle中将其放入一个线程池处理
## 注意
一个事件必须只能交给一个线程处理，不能提交多次
- 由于是异步处理，所以我们提交前必须要修改其状态

# client

# 自定义通讯协议（不用http
- 一般要放一个长度控制
- 比如总长度为4+data序列化后长度
- 4B是一个int，这个int是data的长度
- 往buffer中写一个int，即长度
- 然后往buffer写数据
- 然后flip

# nio读写基本操作

## 读
- 创建buffer
- 设置bytesRead 
- 用bytesRead作为read的返回值
	- 持续从channel中将数据读如buffer
	- bytesRead即读入长度，为-1即已经断开
- 读完（nio使用边缘触发，一次读完
	- flip buffer
	- 然后将buffer.remaining读出来反序列化
## 写
