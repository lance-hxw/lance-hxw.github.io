在kafka的一个consumer group中， 消费者会处理topic中不同的分区
当组成员或者订阅关系发生变化时， kafka将分区重新分配给不同消费者的过程。

触发情况：
- 消费者加入组
- 消费者退出组，其负责的分区需要给其他消费者
- topic 分区扩展，需要更新分配策略
- 协调器故障，需要重新选举并rebalance

rebalance过程
- 检测订阅关系变化
- 暂停消费
- 分区分配
- 同步分配结果
- 继续消费

rebalance影响
- 可以保证：负载均衡+高可用
- 缺点：停顿，影响吞吐和延迟


 优化方式
 - 使用stickyAssignor， 减少不必要的分区移动， 减少reblalance影响
 - 调整消费者timeout，避免心跳超时频繁rebalance
 - 使用cooperative rebalancing， 让rebalance更平滑， 避免大规模迁移