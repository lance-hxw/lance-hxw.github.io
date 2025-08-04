这个是kafka at least once的重要保证

# 提交通道
直接提交到kafka内部一个特殊压缩的topic, \_\_consumer_offsets
每个消费者组group.id在每个分区partition的消费进度都记录在其中

# 提交方式

## 默认自动提交
consumer定期提交上一次调用poll返回的所有消息的偏移量, 也就是每次poll都当做消费完了
- 由于是定时提交, 如果期间宕机会导致重复消费, 并且需要额外的容错机制
- 没有容错就不能at least once了
## 手动提交
消费完一批后手动提交offset
支持:
- 同步提交: commitSync, 阻塞提交, 提交失败能感知, 可以重试
- 异步提交: commitAsync, 异步提交, 吞吐量高, 提交失败无法感知
一般要结合幂等性实现exactly once

## 特别的, consumer可以消费多个分区, 所以可以一次提交多个分区的offset


# 提交什么

一般默认是一整批消费成功, 提交这批最后一个msg的offset+1
也可以提交最后一个成功的msg.offset+1

# 失败

