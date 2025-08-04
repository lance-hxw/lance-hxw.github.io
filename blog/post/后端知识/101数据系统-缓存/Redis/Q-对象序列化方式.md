- Json, 如Gson和jackson等比较成熟
- xml: 少见, 冗长
- 二进制, 如java自己的Serializable, 效率高, 但是不通用
- 自定义: 如果需要特殊格式或者高性能
	- 使用Protocol Buffers , kryo等
**springboot默认使用jackson, 并配置了ObjectMapper