kafka数据结构设计似乎天然分区有序， 但在生产时， kafka为了保证高吞吐， 不是一条一条的发送+等待ack的，而是批量+重试的，此时提供分区顺序性是broker内部需要解决的问题
- 相当于将顺序性复杂度封装在mq中了

# producer端

1. 缓冲区，使用recordAccumulator的双端队列对每个topic进行缓冲
2. 分区器，如sticky会对每个topic的多个分区不断的黏性分区，对单分区形成更大的batch
3. send区， 取出每个分区的batch后，进行发送，需要控制重试和接受ack等

# broker配置与机制

broker面对producer的乱序+重试 请求， 需要保证：
- 顺序性
- 幂等性
需要开启enable.idempotence, 此时client会带上producer（p）id +  epoch + 分区序列号
## 分区顺序性保证

首先，每个分区只有一个leader负责追加写，所以处理的写入请求必然有序
而接受请求时， 开启幂等后， 客户端给每个分区维护连续序列号
- broker会校验序列号递增
- 当出现旧批次失败，后批次到达时， 会阻止后续批次写入，一般保证inflight = 5
## 幂等性保证

基于pid ， epoch，和分区序列号

此时会给每个pid维护最后确认的seq
只接受nextSeq = lastSeq + 1
对于重复， 跳号，倒退的， 都拒绝掉，保证幂等和顺序性

