rocketmq与canal配合非常好， 是一个生态
kafka是更普遍的选择
rabbitmq不适合：
- 主要是吞吐量
- 没有持久化，与cdc不契合
- 多消费者时涉及复制， 开销大