redis 高可用主要使用sentinel或者cluseter
# cluster 选举

集群是多个master和若干replica形成
节点间使用gossip ping pong 交换状态

出现故障时， 多数master报告某个master下线， 就将其标记为fail，并触发其replicas的选主过程

具体过程为， 发现master fail， 每个replica都发起投票请求。

投票者是其他master， 每个epoch中，只能投其中一个replica
- 优先投复制偏移量最大的replica
- 如果offset相同， 用runid裁决
投票完replica成为master

# sentinel选主

哨兵集群监控 一组主从实例， 检测健康状态

健康状态形成quorum， 达到阈值判定master下线

然后根据：
- replica priority选择
- 按复制偏移量选择
- 按与master断联时长选择
- 并考虑心跳延迟
# 选型

需要水平扩展用cluster， 否则哨兵

需要自动容错+扩展性， 用cluster