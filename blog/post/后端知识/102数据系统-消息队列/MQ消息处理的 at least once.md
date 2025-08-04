所谓at least once , 至少一次, 也就是消息不能丢失

基于mq的处理流程包括:
- producer 发msg 到mq
- mq发消息到consumer
- consumer消费
要保证不丢msg, 这三个步骤都要可靠
# AMQP(rabbitmq)可靠性
## 生产者可靠性

### 粗暴方案: 事务
使用事务支持, 阻塞生产者, 直到mq发回ack, 这一般不用

### mq confirm确认
使用setConfirmCallback, 并设置让rabbitmq发confirm回来, 然后处理发送失败的

实际上生产端不容易出问题, 一般也不需要重型处理(而且这种情况往往消息会延迟很久)
一般打个log让人工处理就行

### 生产端持久化

首先是queue可以设置持久化, 消息代理重启还可以继续发
[[rabbitmq 可靠性保证#底层的生产逻辑]]
一个msg可以还先在数据库中存下来, 然后用一个status标记, 收到confirm才设置成1
然后开个xxl-job, 定时将超时且没confirm的重发

## MQ broker 可靠性
broker的可靠性主要靠集群和持久化实现
[[rabbitmq 可靠性保证]]
## 消费者可靠性
这里主要是消息投递到消费者后的ack机制

默认的ack是取出msg就删记录
可以设置为手动ack, 此时必须要及时发ack, 不然会一直在队列中

注意设置的时候, 消费失败重入队, 和重试次数必须一起设, 不然会无限循环

当消费成功才ack, 此时就全流程at least once了

- 注意: rabbitmq没有ack队列, 是用msg的状态来标记的, 被消费的时候是从ready变成了unacked
- 重入队就是unacked再变回ready
	- nack/reject消息, 且要requeue=true
- 消费成功才丢弃


# kafka中的at least once

类似的, kafka也会处理消息丢失问题

## 生产者
acks =1, 或者acks = all, 写入全部副本成功后才ack
重试机制
## broker
kafka自身可靠性(集群+持久化)
[[kafka broker 可靠性保证]]
## 消费者
关闭自动提交offset, 在消费完成后手动调用commitSync()或者commitAsync()
[[kafka 上报offset]]
