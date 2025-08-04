基于redis的java客户端框架， 用于处理分布式任务。
主要提供了如下API
- 分布式锁和同步器
- 分布式集合和映射
- 分布式服务和远程调用
- 分布式执行服务
实现了如下功能：
- 大量分布式对象和api
- 简化api
- 异步操作支持
- 集群支持
	- 原生支持redis集群， 主从复制， 哨兵模式
- 分布式锁
- 自动重连或者故障转移


Redisson原理（如何实现可重入）

# 如何使用redission
```java
Config config = new Config();
config.useSingleServer().setAddress(...);

RedissionClient redission = Redission.create(config);
// 使用单个redis服务器创建一个redission客户端
```
如何使用分布式锁：
```java
RLock lock = redission.getLock("lockName");
lock.lock();
...
lock.unlock();
```