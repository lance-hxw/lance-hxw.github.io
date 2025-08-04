# 基本概念
锁行为和以下条件有关：
- 隔离等级
- 读/写
	- 当前读/普通读
- 单条查询，范围查询
- 有没有索引，在什么索引上查
# RU
读：不上锁，不用mvcc
写：
- 表：意向锁
- 行：X锁
# RC
读：不加锁，但使用mvcc，控制只读取已经提交的
写：
- 表：意向锁
- 行：X锁
# RR
读：
- 普通读： 不上锁，使用MVCC控制一致性
- 当前读：如（for update， lock in share
	- for update 上X锁
	- lock in share 上S锁
写：
- 表： 意向锁
- 行：
	- 修改的行上X锁
	- 范围的更新或者插入，为了防止幻读，加Gap lock
	- 还会上nextkey锁
# Serial
- 完全隔离
- 读：全部加S锁
- 写：
	- 表：意向锁
	- 行：排它锁，还有gap和nextkey， 防止幻读
# next key 与降级
只有R R和Serial会使用nextkey
一般在以下场景使用：
- 范围查询
	- 查一个范围且当前读
- 插入操作
	- 插入范围
- 更新删除（删除范围
	- 对影响范围加nextkey，（如果没有=就会变成gap
- 当前读
	- 此时如果有范围查询，会上nextkey
如果不需要对边界加锁，就变成gap

# 索引的影响
如果是唯一索引
- 命中，就是record
- 范围，就是nextkey
二级索引：
- 命中：可能重复，所以对所有相同值加nextkey
- 范围：nextkey
- 回表：对主索引加record锁