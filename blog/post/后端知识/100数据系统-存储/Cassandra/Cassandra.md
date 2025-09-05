apache cassandra是一个高性能分布式数据库， 主要特点是使用了无主模型

分布式方面：其主要设计源自amazon的dynamo和google的bigtable

存储方面：一个面向列的存储

cassandra支持事务 ， 支持在边缘集群快速写入并在大数据场景下不保证读的效率

# 组件

- node
- data centor 相关节点的集合
- cluster， 若干数据中心的集合
- commit log ，  相当于wal
- mem-table， lsm组件
- sstable， lsm 组件
- bloom filter

# 基本操作
基于CQL语言访问Cassandra， 将keyspace当做表处理

写：
- 每个节点的写入被该节点的commitlog捕获， 然后存memtable， 当memtable满， 写入sstable， 
- 所有写入会自动分区并在集群中复制
- 定期合并sstable
读：
- 先从memtable取
- 检查bloom filter， 找sstable中有没有

# 集群协调

基于gossip

