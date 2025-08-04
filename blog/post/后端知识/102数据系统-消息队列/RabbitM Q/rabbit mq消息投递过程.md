总体基于push结构

- 消息被producer发到exchange并经过binding后, 就存入broker维护的q
- broker从这个q中直接将msg deliver到consumer
	- 对每个注册/订阅的consumer维护一个待发送窗口(由prefetch决定)
	- 一旦队列中有消息, 且该消费者窗口没满, 就通过AMQP.basic.deliver, 将消息发到消费者对应的tcp连接
	- 消费者client收到msg, 触发回调, 如handleDelivery进行消费
		- 如果手动ack, 还要再调用basic.ack
- 消费者确认后,  broker移除消息
	- 如果是自动ACK, 那么broker进行deliver的时候就移除了
	- 手动ack, 会在消费者处理完, 再调用basic.ack后才移除

# push的特点
- 低延迟, 可以立即送达
- 如果消费者处理慢, 可能堵住
- 相对不容易拓展

在此种结构下, rabbit的消费进度本质是broker控制的, 一个msg被成功消费后会从broker中移除
# prefetch
连接时, consumer指定自己能被同时推送多少msg, 并将这个称为QoS服务质量
# in-flight window
rabbit, 或者说AMQP中, 基于prefetch参数设置的un-acked messages的最大数量窗口
其主要作用是:
- 流量控制
- back-pressure
其实现是一个记数器, 计算该consumer的所有un-acked消息

如果auto ack, 这个就没意义了, 强烈不建议auto ack

这个窗口设置, 或者说prefetch设置
# client 长连接
基于tcp的长连接, 并且可以使用多个AMQP channel连接多个队列, 并使用心跳机制


