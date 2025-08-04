KV数据库， 可以做：
- 缓存
- 消息队列
- 分布式锁
- 排行， 计数
- 会话
- 发布订阅
- 事件流
- 向量数据库
redis 是基于c语言写的
一个redis可以分成多个数据库, 每个数据库中的key, 可通过:表达层级关系
## 部署
使用docker部署
[史上最详细Docker安装Redis （含每一步的图解）实战_docker redis-CSDN博客](https://blog.csdn.net/weixin_45821811/article/details/116211724)
[Docker安装Redis并配置文件启动-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1997596)
- pull
- 搞个volum备用
- 启动
启动命令：
```bash
// 指定配置文件
docker run --name redis \
	-p 6379:6379 \
	-v /docker-data/redis/redis.conf:/etc/redis/redis.conf \
	 -v /docker-data/redis:/data \ 
	 -d 
	 redis redis-server /etc/redis/redis.conf 
	 --appendonly yes
```

简易启动：
```bash
docker run -p 6379:6379 --name xxx --requirepass xxxx
```

### 配置
- bind ， 去掉对127的绑定， 不然只能本机访问
	- 改成bind 0.0.0.0
- protected-mode no: yes表示只准本地回环链接
- daemonize no： docker方式保持no， 不开启守护进程
- requirepass xxxxx： 设置密码
- appendonly yes：开启持久化
### 连接
命令行， 使用redis-cli进入（不过用docker这样就不方便了）
在idea中， 数据库页面选择连接redis即可， redis的默认用户是default
## 数据类型
[Redis 5 种基本数据类型详解 | JavaGuide](https://javaguide.cn/database/redis/redis-data-structures-01.html)
### 基本数据类型
- String: 
	- 可以是字符串, 整型, 浮点数
	- 可以对字符串进行字符串操作
	- 对数字类型进行自增/减
	- 用于
		- 缓存对象(序列化), 
		- 计数
		- 分布式锁
		- session等
- List
	- 链表, 每个节点都是一个字符串
	- 在两段进行push和pop, 可以根据值查找和删除元素
	- 用于
		- 消息队列(但是需要生产者自行实现全局唯一id, 没有消费组)
- Hash
	- 缓存对象
	- 购物车
- Set
	- 字符串的无序集合
	- 聚合计算场景, 如点赞, 共同关注, 抽奖
- Zset
	- 类似hash的键值对
	- 排序场景, 如排行榜, 电话, 姓名排序




" Redis 3.2 之前，List 底层实现是 LinkedList 或者 ZipList。 Redis 3.2 之后，引入了 LinkedList 和 ZipList 的结合 QuickList，List 的底层实现变为 QuickList。从 Redis 7.0 开始， ZipList 被 ListPack 取代。" 
[[SDS 简单动态字符串]][[双端List, QuickList, ZipList和ListPack]]...

### 特殊数据类型
- bitmap
- Hyperloglog: 基数统计(有误差高性能)
- Geospatial(地理位置)
- stream, 消息队列, 自动生成全局唯一消息id


## 操作
通用操作有:
 - KEYS
 - EXISTS
 - TYPE
 - DEL

### String, 可以存储多种数据
- SET , SETNX(只在不存在时设置)
- GET
- MSET K V K V K V
- MGET K K K K
- STRLEN K
- INCR key  字符串中数字增
- DECR key 字符串中数字减
- DEL
- EXISTS k
- EXPIRE k 设置过期时间
	- 默认是-1不过期, -2是已经过期, 否则为剩余时长
	- 可以用TTL查询
### List, redis中的list是双端链表
- R/LPUSH k v v v v: push元素, 注意v的顺序, 先push的离边界远
- LSET k index v: 随机写
- L/RPOP: 左右pop并获取
- LLEN: 元素数量
- LRANGE k s e: 切片, 获取s和e间元素
### Hash, 基于数组和链表, 但有很多优化
- HSET k field v, 指定字段的值
- HSETNX
- HMSET k fv  fv fv
- HGET k f
- HMGET k fff
- HGETALL k, 所有键值对
- HEXISTS k f: k中f是否存在
- HDEL k f f 
- HLEN k 字段数
- HINCRBY k f increment, 将指定字段加减(用正负值表示)
### Set
- SADD
- SMEMBERS key: 获取所有元素
- SCARD: 元素数量
- SISMENBER k m 是否存在与
- SINTER k k :两个集合的交
- SINTERSTORE d k k: 将交集存于d中
- SUNION: 并
- SDIFF: 差
- 存并/差
- SPOP k count: 随机获取并移除一个或多个元素
- SRANDMEMBER key count, 随机获取多个元素

### 有序Set, 元素有一个score权重, 按这个排序
- ZADD
- ZCARD
- ZSCORE k menber: 获取指定元素score
- ZRANGE k s e: 获取切片,低到高
- ZREVRANGE kse: 高到低
- ZREVRANK k m: 获取指定元素排名(高到低)
- 其余和Set类似
## 特性
默认有0-15个隔离的数据库, 默认使用0
### 持久化

## java中使用redis
可用的有:
- Jedis
- lettuce: netty
- Spring data redis 更简单

### Spring Data Redis
- maven导入
- xml配置redis
- 使用配置类导入, 实例化一个对象
- 使用对象操作redis
实例化RedisTemplate后, 使用opsforValue/Hash/List等获取操作类
redis中的string实际相当于序列化结果, 所以, java中对应的操作都是对一个obj的操作(所以返回的都是obj, 需要转换成string)
