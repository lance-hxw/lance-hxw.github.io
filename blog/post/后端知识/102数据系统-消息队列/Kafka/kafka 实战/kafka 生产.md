producer会和broker建立联系，可以感知broker的配置

producer的主要配置就是
- server
- kv serializer
- acks
# 生产时p-b通讯
producer会根据规则在本地处理topic和分区号，然后发送到broker

broker接受后返回metadata
```bash
ProduceResponse
- throttle_time_ms 限流等待时间
- responses[]  每个topic的响应
  - topic
    - partitions[] 每个分区的响应
      - partition
	  - error_code 0 成功
	  - base_offset 
	  - log_append_time_ms 写入时间戳
	  - log_start_offset 
```

最终写入的分区按metadata确定，因为有broker自动创建topic的需求（但是这个功能似乎很不生产）

# 发送过程

代码中多次调用send， 最后producer还是会批量发送，保证性能

代码send是将msg放到缓冲区，发送会有一个独立后台线程负责（这是个资源，需要try-with-resources

# acks
