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

纯手动提交：
	

## 特别的, consumer可以消费多个分区, 所以可以一次提交多个分区的offset

## offset如何维护

有一个   
```java
@Override
public void commitSync(Duration timeout) {
	commitSync(subscriptions.allConsumed(), timeout);
}
```

其中每次poll都会 在 fetchRecords中把subscriptions中的postion的每个分区的offset更新掉

然后在commit的时候上报 这个allConsumed返回的Map\<TopicPartition, OffsetAndMetadata> 


# 提交什么

一般默认是一整批消费成功, 提交这批最后一个msg的offset+1
也可以提交最后一个成功的msg.offset+1

# offset提交对并发的影响

每个分区只能被同一个消费者中的一个消费者消费， 无论这个消费者是在干什么，也就是说， 哪怕消费者立即提交offset， 也没有其他消费者来poll这个分区的msg去处理， 绝对不会破坏顺序性。
- 所以不需要担心多消费者并发问题

只涉及同一消费者的提交时机

# 失败处理

[[kafka重试（可靠性保证）]]
