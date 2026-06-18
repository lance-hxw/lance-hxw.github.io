consumer主要配置
- server
- serializer
- 自动提交
- offset reset
- 消费者组id

指定一个group id
然后创建一个consumer加入group中

后续拉的时候，按group的配置去处理，并触发rebalance进行负载均衡

# c-b 连接配置

## 连接上去
- 向servers 发送Findcoordinator，找到broker
- 发送JoinGroup，然后分配得到group对应的partition，和一个metadata
- 发送SyncGroup请求，确认分配方案
- 发送OffsetFetch，获取各个分区的offset
## 存活性
- 心跳
- max poll interval  ms，默认5min不poll就掉线踢掉

## 一个consumer维护的状态和存储位置：

**消费者维护的关键状态**

| 状态                       | 存储位置                             | 作用                                  |
| ------------------------ | -------------------------------- | ----------------------------------- |
| **committed offset**     | broker（__consumer_offsets topic） | 记录"已成功处理到哪里"，用于重启后恢复                |
| **current position**     | 消费者内存                            | 下次 poll 从哪个 offset 开始拉              |
| **group membership**     | Coordinator                      | 哪些消费者属于这个 group                     |
| **partition assignment** | 消费者内存                            | 我负责消费哪些分区                           |
| **heartbeat**            | Coordinator                      | session.timeout.ms 内必须收到，否则踢出 group |
| **last poll timestamp**  | 消费者内存                            | 超过 max.poll.interval.ms 未 poll 则被踢出 |

# c-b通讯

根据一个等待上限时间，去poll，拿到一个ConsumerRecords KV数据

其内部是一个Map\<TopicPartion, List\<Record> >

每个分区对应一个按offset排序的消息列表

每个record 包含了
- topic， partition， offset
- timestamp， timestampType
- key value
- headers

## 每次poll内部：

- 心跳向coordinator间隔发送
- FetchRequest向各个partition的leader broker按配置拉数据
- 期间可能触发rebalance

# offset过期

auto offset reset 设置 可以指定如何处理offset情况
- 从头
- 最新
- 没有offset直接报错

这个过期的逻辑是， broker会在本地维护一个7天活跃保留的offset，过期就删除

这个设计的出发点是：
- 很多consumer是临时的或者 废弃的，需要垃圾回收
- kafka设计哲学就是，应该让consumer自行维护，如果有这方面需求，就应该自行处理，不依赖broker


# offset自动提交

关掉自动提交后， 需要用consumer.commitSync提交

