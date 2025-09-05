
es对外提供index概念， 用户的查询在index上完成

每个index由若干个shard组成， 达成分布式可扩展，每个shard对应lucene的library

对于每个shard， 有translog的功能， 作为wal

具体存储结构， 取决于lucene的存储结构
[[lucene 存储结构]]
