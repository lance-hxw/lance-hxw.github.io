逻辑上主要分成两层:
- 核心引擎, 处理消息储存, 路由, 持久化
- 适配层: 可以支持多种协议
	- AMQP091
	- AMQP1.0
	- MQTT(轻量级 物联网)
	- STOMP(简单文本协议)
	- HTTP/WS (web)
所以rabbitMQ的客户端本质是协议的客户端, 比如直接用一个AMQP091客户端去连接rabbitmq提供的AMQP091服务

rocketMQ也支持AMQP

# 架构&概念

## exchange
消息路由中心, 根据路由规则, 将msg转发到相应队列
- direct exchange, 用routing key 匹配
- topic exchange, routingkey中用通配符模式\*表示一个词, \#表示0或多个
- fanout exchange, 广播, 直接忽略routingkey, 发到所有binding的队列
- headers exchange, 根据消息头进行路由
## queue
fifo队列, 支持持久化, 排他性, 自动删除
## binding
定义exchange如何到queue, binding有bindingkey, exchange需要根据bindingkey和routingkey进行匹配
创建绑定的时候, 要指定bindingkey, 用于和routing匹配
## 消息传递过程
producer连接mq, 通过长连接中, AMQP的channel发送到指定exchange, exchange根据binding将msg发到队列, 然后等待消费
## 连接管理
TCP长连接, channel是在TCP上的虚拟连接, 可以连接复用

