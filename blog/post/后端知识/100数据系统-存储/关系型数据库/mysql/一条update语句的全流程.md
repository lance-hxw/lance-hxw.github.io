UPDATE t_user SET name = 'xiaolin' WHERE id = 1;
# innodb前
解析句法, 优化后交给执行器, 调用innodb接口
# innodb中
## 搜索 id = 1的数据
- 如果在buffer pool 找到, 直接返回数据页
- 否则就得去找数据页写入buffer, 然后返回
## 从页面中得到主索引数据
- 检查update前后数据有没有变化, 如果没有就不处理
- 如果有变化: 将更新前数据和更新后当参数传回innodb
## 开启一个事务(所有sql都是事务)
- 开始写undo记录, 因为是update , 得写旧值
- 同时开始写redo
## innodb更新记录
- 更新内存, 标记为脏页, 写redo, 认定更新完成
## 开始记录binlog
先写如缓存, 事务提交时刷到磁盘
## 事务提交, 2pc 保证redo和bin的一致性
- 设置redo事务状态prepare, 写redo
- 写bin log, 调用事务提交, 将redo log设置为commit, 然后写redo
