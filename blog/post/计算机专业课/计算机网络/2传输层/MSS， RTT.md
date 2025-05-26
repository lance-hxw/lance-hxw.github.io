# Maximum Segment Size
tcp中的最大分段大小，表示tcp数据包中可以容纳的数据部分最大长度，不包括tcp头和ip头
MTU（最大传输单元）减去TCP头和IP头就是M S S

# Round Trip Time 往返时间
根据测量值得到的性能参数：
- 确定RTO
- 影响拥塞控制
- 影响tcp吞吐
如何测量：使用TCP，ICMP等方式