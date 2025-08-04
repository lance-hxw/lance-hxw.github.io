rabbitMQ中是消息粒度的ack, 所以更exactly once, 但是还是不完全的

事实上, 大部分mq都只能保证 at least once, 至少一次, 也就是重复消费不可避免

需要配合幂等性才能实现exactly once