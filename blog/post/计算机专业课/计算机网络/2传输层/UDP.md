# UDP

在IP上加了一点功能，分用复用和差错检测

## 特点

- 无连接
- 尽最大努力交付，即不保证可靠
- 面向报文： 一次交付 一个完整的报文，如果太长，由IP完成分片
- 没有拥塞控制，即使堵塞也不会降低源主机的发送效率，即，运行丢失一些数据，但不允许高时延
- 支持一对一，一对多，多对一，多对多
- 首部开销小，只有8B

无拥塞控制可能导致严重堵塞，可能需要重传


- 注意： 这玩意是面向端口的，也就是说，他是发送到一个端口，而这个端口在哪个主机上，是网络层的事。
## 首部格式

4个字段，每个2B：

- 源端口：需要回信使用，不需要回复用全0
- 目的端口：必须
- 长度：数据报长度，最小8（整体长度，最小是首部8B）
- 检验和：检验

#### 校验和计算：

需要在UDP数据报前加上12bit的伪首部，是临时添加的，仅作校验