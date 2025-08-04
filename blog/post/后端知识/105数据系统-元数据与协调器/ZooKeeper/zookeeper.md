## zookeeper和大数据原理
理论知识见 大数据课程笔记: [[计算机知识/hadoop/ZooKeeper|ZooKeeper]]

## 使用场景
### 用于分布式场景各个节点配置同步:
如kafka集群中, 修改配置文件后, 同步到所有节点上
### 配置信息管理
将特定配置写入一个znode中, 然后设置watch, 所有client监听他, 这个配置被修改的时候, 通知所有client
### 分布式锁和分布式选举
谁创建临时znode成功, 谁就拿到了锁/leader
### 软负载均衡
通过对每个持久znode监控, 将任务分配到不同的节点

## 实战: 部署zk
### 安装zk
...
### 可选配置: zoo.cfg 中
- tickTime : 心跳时长(ms), 最小的session超时时长为2个心跳
- linitLimit: 初始通讯建立时最长时长, 单位是心跳数
- syncLimit: 后续通讯时长, 如果超过就认为follower宕机
- dataDir: 数据持久化目录, 默认tmp容易被linux定期删除
- clientPort: 客户端连接的端口
- \#cluster
	- server.myid = server_addr:port1:port2
		- 其中myid是唯一标识
		- server_addr是节点地址
		- port1是FL通讯
		- port2用于选举通讯
### 操作zk
- 启动服务端: 使用zkServer.sh start命令启动zk
	- 然后用jps查看是否有进程
	- 状态: 使用zkServer.sh status
	- 停机: zkServer.sh stop
- 启动client: zkCli.sh
	- 退出client: quit
### 集群up
- 在每个集群上安装zk, 并在zkData目录下创建myid文件, 分别设置为各自编号(myid大的优先级高)
- 然后同步zoo.cfg, 包括cluster信息
- 然后在所有机器上启动zk
	- 如果刚启动第一个时, 此时zk是未启动状态
		- 因为设置了集群有三个节点, 此时只活了一个, 还没进行选举, 集群就不能工作
	- 启动第二个时, myid大的那个就变成leader了, zk启动
### 集群down

可以去每个节点分别down, 也可以写一个脚本, 直接down所有集群, 注意脚本的权限设置
## 实战: 使用client使用zk

### 打开会话
- 在本地使用zk的zkCli.sh 打开一个session
- 使用zkCli.sh -server server_addr:port
### 可用操作
- 查看当前znode内容: ls /
- 看znode数据:
	- 命令是: ls2 /
	- czxid: 创建时的zxid
		- 每次修改zk状态都会产生一个事务id, 是集群中总的修改次序, 每次修改都会递增zxid, 越大说明越新
	- ctime: 被创建的毫秒数
	- mzxid: 最后修改的zxid
	- mtime: 最后修改时间
	- pZxid: 子节点最新zxid
	- cversion: 子节点变化号/修改次数
	- dataversion: 数据变化号
	- aclVersion: acl的变化号
	- ephemeralOwner: 如果是临时节点, 这个是该znode的拥有者的sessionid, 否则为0
	- datalength: 数据长度
	- numChildren: 子节点数
- 创建两个永久节点:
	- create /aaa/bbb "data1"
	- create /aaa "data"
	- 节点用路径表示
- 创建带序号/顺序的永久节点:
	- create -s /aaa "data"
	- 带序号的永久节点可以重名, 即aaa1, 创建时会自动+1序号
- 创建临时节点:
	- create -e /aaa
	- 结束会话后节点就消失
- 获取节点值: 不仅有数据, 还有元数据
	- get -s /aaa
	- get -s /aaa/bbb
	- -s是显示节点信息
- 修改节点值
	- set -s /aaa "datab"
- 删节点:
	- delete path
- 递归删
	- deleteall path
- 看状态
	- stat path
### 监听: 一个监听进程一个通讯进程, 注册检测器方式
注意: 注册一次只能监听一次
- 监听节点数据变化: 
	- get path \[watch]
- 监听子节点增减:
	- ls path \[watch]
- 监听值变化
	- get -w path
	- WATCHER:: watchedEvent state: nodedatachanged , path 
## 实战: 在java中使用zk
使用org.apache.zookeeper依赖,
创建zk客户端实例:
new ZooKeeper(connectString, seesionTimeout, Watcher())
其中connectString为: "server_addr:port", 如"192.168
.0.1:2181"
Watcher里应该有一个process接受WatchedEvent

创建子节点: 
zkClient.create("/xxx", data, ...)
...
# Ref.

[超全zookeeper知识点与实战-CSDN博客](https://blog.csdn.net/m0_46413065/article/details/121569143)


# 节点类型
- 持久节点，用于配置元数据，全局数据
- 临时节点， 随client自动删除，用于服务注册发现，会话状态跟踪
- 持久顺序：分布式队列，优先级调度
- 临时顺序：分布式锁，竞争资源分配
## 顺序节点：
当你用一个path生成节点时，他在后面自动追加10位单调增序号，这个是父节点维护的，已删除节点的序号不会复用

# 核心功能
- 分布式协调与锁
	- 通过临时顺序节点+watch
- 服务注册与发现
	- 使用临时节点
	- 通过watch监视可用服务
- 集群选主：
	- 在leader目录下创建临时顺序节点用于选举
- 配置管理：
	- 如在create：/config/xx.url “http。。。”
	- 然后客户端可以watch这个节点更新配置
- 分布式队列
	- 通过持久顺序节点
	- 不断消费最小序号的节点
# 底层：ZAB原子广播+watch

# 适用于：CP强一致性系统，写入需谨慎