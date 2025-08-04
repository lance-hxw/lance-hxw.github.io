

# 架构设计
## 持久化

kafka的msg是日志形式存在磁盘上的, 使用offset进行标记消费

## 副本
每个分区有多个副本, 并混布在多个broker中(这样对不同分区的leader负载均衡了)
leader和follower是副本间的关系

每个分区都是一个单主模型

**事实上**, kafka的follower并不能被consumer读写, 他只是用于数据同步的, 用于形成写入确认的quorum


## ISR : in-sync replica
与leader数据一致的副本

## zk/kraft 一致性保证

一般情况下在ISR副本中进行leader选举
如果所有ISR都宕机, 会在所有副本中进行unclean leader election
- 当然, 这可以设置, 也可以持续宕机等ISR恢复一个

不允许unclean 就是CP, 否则AP

# broker宕机

## 消费者/生产者
如果一个分区的leader在这个broker上, 立马不可用

## zk/controller
检测到多个分区的多个副本下线
清理各个分区的ISR, 对丢失leader的分区进行选举

## 数据一致性
- 如果ISR没有完全宕机, 无影响(生产者生产不进来没做可靠性的没办法)
- 如果ISR全没了, 而且进行了unclean 选举, 就有不一致