是一种轻量化, 无持久化的消息通讯机制, 其逻辑为:
- publisher将消息发送到某个channel
- subscriber提前监听channel, 就能实时收到消息
- redis进行转发, 不存数据

订阅的粒度可以是精确的频道, 或者一个模式匹配, 可以认为这是一个topic

