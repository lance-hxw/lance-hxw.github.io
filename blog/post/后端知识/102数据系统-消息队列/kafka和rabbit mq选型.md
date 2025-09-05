# 发布订阅功能

rabbitmq发布订阅使用消息复制， 性能低， 资源消耗高

kafka的消息订阅不是基于复制的， 而是直接获取持久化的日志消息， 消费者消费时自己找

# 顺序场景

为了实现顺序， rabbitmq需要：
- 单消费者+prefetch=1
- 存在重新入队情况，此时如果是单消费者还能主动处理， 多消费者在业务层处理顺序性更复杂（分布式状态）

但是kafka不会重新入队， 只会再去拉



# 吞吐：kafka多分区并发

rabbitmq 大量msg发在一个队列中， 吞吐受限

kafka可以订单分区， 多分区并发


# 消息匹配：rabbitmq 匹配更灵活

如果订阅关系非常复杂

rabbitmq支持routing_key, 或者自定义消息头， 加上特殊exchange， 会非常灵活和方便[[rabbit mq 消息路由]]

kafka复杂匹配会很难， 因为是消费时去日志中找数据，也就是对日志结构存储的精确和模糊匹配

# 消息超时： rabbit mq 延迟交换机完胜

延迟队列方面

rabbit 自带ttl， 超时进死信， 不过直接消费死信不行
- 就算有不同过期时间， msg之间还是会保证FIFO，也就是早就过期还是会等前面的msg过期进死信

delayed message exchange插件可以解决这个问题， 原理是交换机中进行延迟， 到期放入队列

在kafka中实现延迟队列就非常麻烦了
需要用一个topic接收原始msg， 然后用一个延迟消费者进行延迟操作， 这个延迟服务还要做持久化，这个太麻烦了


# 消息重放：只有kafka可以

rabbitmq这时候直接歇逼， 做不了一点

kafka只要磁盘够就行， 去找日志文件重复消费

# 消费失败处理

单分区消费失败， 就只能停止，而不能继续消费后面的

如果没有非常精确的需求， 使用kafka会降低可用性

此时rabbitmq更灵活

# 运维与易用性

rabbit 运维简单， kafka集群复杂， 参数多

kafka 生产消费使用起来非常复杂， 生产者就很麻烦， 消费者还要做日志偏移管理， 这就非常麻烦了。


# Ref.

[Kafka和RabbitMQ有哪些区别，各自适合什么场景？ - 四猿外 - 博客园](https://www.cnblogs.com/siyuanwai/p/15770079.html)
[RabbitMQ 与 Kafka：消息中间件的终极对比与选型指南_消息中间件kafka,rabbitmq-CSDN博客](https://blog.csdn.net/weixin_63443072/article/details/146387509)