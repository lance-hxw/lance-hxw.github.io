目前最著名的K V存储引擎是RocksDB，从levelDB演化而来
Mongo和mysql的底层都可以切换成RocksDB， TiDB直接使用RocksDB，大多数分布式数据库的底层都是RocksDB
- 在流处理系统中，flink和kafka的streams都使用了
- 在消息队列中
- 在搜索引擎中用于倒排索引
- 本地持久化kv存储
特别适用于SSD上的性能
- 必须是闪存
竞品
- levelDB是rocksDB的前身
- lmdb，sqlite等还是关系型
- pebble和go生态结合更好，是后来者
# LevelDB
随机写是非常慢的， 内存的随机写和磁盘的顺序读一个水平（这个是争议问题，不过两者水平是一个量级的）
- 避免随机的一个最关键点就是： 避免update/delete，最好是一直在顺序写
- 这个例子不是说leveldb是内存数据库哦。。
leveldb的核心设计是sstble（sorted string table）
## sstable
是一组按key排序的kv对，key和value都是字节数组
分布在内存和磁盘中（一般是ssd
sstable的底层是LSM Tree （LogStructured Merge Tree）

## levelDB组成
- Memtable：内存sstable，新数据写这里，然后写磁盘
- log：写memtable前写磁盘，WAL
- immutable memtbale：如果内存中的memtable达到指定大小，就不接受新数据，然后生成新的memtable用于接受
	- 原来的memtable变为”不可变的"，然后写盘成sst文件
- sstable文件集合：硬盘上的sstable文件，不可变， 文件尾有key-offset的索引用于随机读
	- sst文件是分层排布的，分成level0-N层，每层都有多个sst文件
	- level0的sst是immutable memtable直接dump得到的原始文件
	- 后续level的sst是上一层文件归并得到的
	- 越往上层，单个sst文件越大
- manifest文件，记录sst文件在不同level的分布，单个sst文件的（key有序）最大最小key和元信息
- current文件，记录当前所有manifest的文件名
	- manifest可能有很多个
## levelDB设计思路
- sst的文件尾索引放内存里
- 写操作：只能写memtable
- 读操作：先读memtable，然后看索引去查，从新向老的读
- 定期写immutable memtable到硬盘并新建memtable
- 定期mergesst，构建level关系
硬盘sst是不能修改的，如何update/delete呢
- update: 追加一个新的kv对到文件尾，读的时候先读到新的
- delete：追加一个墓碑值（tombstone），合并时检测这些墓碑，然后删除这些key

## 具体文件格式
### manifest
一个表格，每行是：
level ？， xxx.sst, "key1", "key n"
层级，sst文件名，最小key，最大key

### log（WAL
读取写入以block为单位

### SST
完整数据（文件）分成若干堆叠的Data块，meta块，meta块index和data块index，最后带有footer
其中data块包括若干记录，n个restart记录和num_restarts
- 这个data里面为了省空间，会记录key的公共前缀，这回导致随机访问不好，就需要restart来
- 总的来说是一种优化，少量空间换时间和更大空间，类似索引
data块index记录了key对应的offset和size

### Memtable
内存底层是一个skip list

## 具体操作

### 写新数据
- 写log
- 如果写log成功，就插memtable
- 写新kv在skiplist对应位置
### 更新
- 写在新的memtable中
### 删除
- 写墓碑值，让这个key被忽略掉
### 读
- 先读memtable(skip-list)
- 基于manifest进行二分找sst文件
- 使用了页面缓存
- 使用了bloom filter
- 进行周期的层归并
