# BIO， NIO， AIO
## blocking IO， 传统java io
基于流模型，交互方式是同步阻塞
## Non-blocking IO，1.7后，无锁
提供了Channel，Selector，Buffer等抽象，可以实现多路复用的同步非阻塞IO
## Asynchronous IO，1.7后， 异步IO
基于时间和回调，没有阻塞

# NIO实现
同步非阻塞，数据总是从channel到buffer中，或者从buffer中到channel中，这在每个io线程中都由一个selector多路复用器控制。
其模型是多个client注册channel
# Netty
#TODO 