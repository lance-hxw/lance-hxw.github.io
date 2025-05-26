# BIO， NIO， AIO
## blocking IO， 传统java io， 用于固定且小规模io
基于流模型，交互方式是同步阻塞
## new/Non-blocking IO，1.7后，无锁， 同步非阻塞，用于连接数目多但是短
基于块，有了缓冲，但是不够简单
提供了Channel，Selector，Buffer等抽象，可以实现多路复用的同步非阻塞IO
- 数据先写到缓冲区中， 然后可以进行重复读取或者移动指针
- Channel： 代表了与fd之间的链接， 可以进行双向数据传输（流一般是单向）
- selector： 允许一个线程管理多个管道， 可以监听管道io事件进行决策， 即实现多路复用

## Asynchronous IO，1.7后， 异步非阻塞IO， 连接多且全是长连接，复杂
基于时间和回调，没有阻塞
有异步通道，且有文件和套接字通道

# NIO实现
同步非阻塞，数据总是从channel到buffer中，或者从buffer中到channel中，这在每个io线程中都由一个selector多路复用器控制。
其模型是多个client注册channel
# Netty
#TODO 