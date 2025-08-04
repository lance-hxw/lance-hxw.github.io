- redo log, 持久性保证, 掉电故障恢复
- undo log, 原子性保证, 事务回滚和mvcc
- bin log, server层的二进制日志,用于主从复制和数据备份(逻辑日志)
- relay log, 中继日志, 主从复制场景下, 通过io线程拷贝master的bin log本地生成日志
- 慢查询日志, 记录执行时间过长的sql, 要手动开启并设置阈值

# bin log: 只记录变动, 不记录数据写入磁盘没
只 **记录已经提交的事务** , 他不能用于故障恢复, 两者可能逻辑不一致
server层记录表结构和数据的变动, 在每个写操作后server层记录
- 追加写, 写满再开一个文件写, 全量日志, 用于备份恢复和主从复制
- 只记录写, 不记录读
## 格式类型
- statement(默认) 每条sql都记录, 这种叫逻辑日志, 主从复制时, 根据sql重现, 但是这种有动态函数问题, 如果用了uuid或者now等函数, 就无法复现了, 导致数据不一致
- row: 记录行数据修改后的样子, 这不是逻辑日志, 没有动态函数问题, 但是会让binlog非常大
	- 不仅要记录完整数据, 而且一个update修改大量记录时, 还会记录所有涉及的新记录值
- mixed
	- 自动使用statement或者row模式
# Undo log
用于回滚, 保证原子性
## 事务的生命周期
- 事务开始
- 执行事务
	- 此时记录undo log
- 期间是否崩溃
	- 崩溃: 根据undo log回滚
- 执行完是否提交
	- 不提交: 根据undo log回滚
- 提交
## 不同操作的log
- insert : 记录主键值, 回滚只需要删除记录
- update: 记录更新列的旧值
- delete: 记录列的完整信息
# redo log & WAL(write - ahead logging)
用一个内存中的缓冲池进行读写优化
当一个更新来时, 先更新缓冲池, 然后写redo log, 然后认定为更新完成
- 此时redolog已经落盘
- 等待特定时机, 将缓冲池中的脏页写入磁盘
redo log是直接对页面修改, 记录xxx表空间中yyy数据页的zzz偏移量数据做了什么更新
事务提交时, redo log 写完就行, 不用等脏页写入
崩溃重启时, 可以用redo log, 通过log seq number 确定从哪里开始应用redo log

此外, redolog是顺序写, 这也让写操作变得更加快速, 即提升了事务性能

# 2pc进行log 协调
但是不能叫XA事务 , 更轻量
当innodb中事务提交时, 会进入一个2pc流程
## prepare 
写事务id到redo log, 设置事务状态prepare, 写redo log到磁盘
## commit
将事务id写入binlog, 然后将binlog持久化到磁盘, 
然后调用事务提交, 将redolog中事务状态设置为commit
## 一致性保证逻辑, 注意宕机时要根据落盘与否判断是否写成功
关键在于binlog写是否成功
当redolog写完
如果binlog写成功了
- 事务可以提交
如果binlog没写(找不到)
- 回滚
## 相关设置
sync_binlog
innodb_flush_log_at_trx_commiti这两个要都设置为1, 才能实现最高级别一致性