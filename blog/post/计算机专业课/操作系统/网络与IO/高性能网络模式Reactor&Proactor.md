# Reactor： redis、nginx、netty
基于IO多路复用的网络模式，即对事件反应
来了一个事件，就进行响应
也可以称为Dispatcher模式， 基于IO多路复用的分配模式
## 核心抽象
- Reactor：监听和分发事件，如连接事件，读写事件
- 处理资源池：处理实际事件，如”读数据，操作，返回“
## 不同种类的Reactor模式
两个变量：
- reactor可以只有一个，也可以多个
- 处理资源池，可以只是一个，也可以是多个
注意他们都可以是进程或者线程
其中，多个reactor+单线程处理， 这个简直莫名其妙，没人用，主要有三种应用方法：
- 单 reactor， 单处理
- 单 reactor， 多处理
- 多 reactor， 多处理
还有用线程还是进程的区别， 这和用户app有关
- java一般用线程， 如netty中
- c都可以， nginx是进程， memcache用线程