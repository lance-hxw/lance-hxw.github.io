## 明确的数据模型, 文档和注释
- 使用java对象封装redis数据, 而不是直接操作redis的原始数据类型
- 使用类型注释, 即在key中命名指定数据类型
## 使用序列化工具
- 一般把java对象序列化存字符串
- 使用Jackson或者Gson等, 将对象序列化为json
	- 或者自定义序列化格式, 如Protobuf或kryo
## 统一封装Redis操作
jackson中提供了objectMapper, 可以统一格式化后, 指定类来readValue(json, clazz)

## 类型校验
使用校验确保无误

## 生命周期管理
- 给不同的数据类型涉及专业的keyspace
	- 这是逻辑上的, 即使用前缀如string:
## 结合Redis数据类型
- 如果合适, 就用匹配的
- 复杂的可以用Hash类型