[[消息系统两大流派]]

# 基本性质
## at least once 不丢失, 可靠性
[[MQ消息处理的 at least once]]

## at most once 不重复
[[MQ消息处理的幂等性与消息重复]]

## 顺序性
[[MQ消息处理的 顺序性]]

## 消费失败容错
rabbit[[MQ消息处理的 at least once#消费者可靠性]]
kafka[[kafka 消息投递]]

# 具体实现

## 路由
[[kafka 路由]]
[[rabbit mq 服务架构#exchange]]

## 消息投递
[[rabbit mq消息投递过程]]
[[kafka 消息投递]]

## 系统架构
[[rabbit mq 服务架构]]
[[kafka ISR]] 
[[kafka 元信息]]
[[kafka与zk]]

## DLQ
[[DLQ死信队列]]

# 集群化如何实现功能

[[rabbitmq 集群]]

[[kafka ISR]]
[[kafka broker 可靠性保证]]
# 应用
## 具体实践
[[MQ选型]]

# 处理问题
[[消息积压]]


