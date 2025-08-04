# Leader
ISR是一个有序副本列表, 这个副本顺序是按一个优化顺序(尽可能负载均衡)设置的
ISR的第一个replica就是首选副本
默认情况下, 每个分片的leader就是首选副本
如果broker宕机导致某个首选副本不可用, 此时会发生选主, 导致leader不是首选
此时还有preferred replica election, 用于恢复首选leader:
- controller要求当前leader下台, 然后向preferred replica发消息让他上台(如果在还在ISR中)
- 系统短暂not leader or follower
# 副本同步

对于每个副本, 都有一个Log End offset, 同步位置
然后对每个分区, 维护一个High watermark, 标记所有ISR都有的数据
consumer只能看见HW对应的msg

## producer ack
只有ISR参与写入判定, 如acks = all, 就需要所有ISR副本都同步到, 此时保证producer写入和consumer允许消费时完全一致的

# ISR如何判定

初始情况下, 所有副本都在ISR中, 然后有的宕机才会被踢出

使用超时时间确认ISR, 这个本质是健康检测, 不是考察数据一致性
这个超时是通过follower上一次fetch时间决定的

## 重新加入ISR

需要先同步, 即一直fetch, 直到LEO 等于leader的LEO, 才允许他加入
- 加入后可以落后一点点