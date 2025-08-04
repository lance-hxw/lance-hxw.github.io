
### 执行频次
查看当前数据库的 INSERT, UPDATE, DELETE, SELECT 访问频次：  
`SHOW GLOBAL STATUS LIKE 'Com_______';` 或者 `SHOW SESSION STATUS LIKE 'Com_______';`  
例：`show global status like 'Com_______'`

### 慢查询日志
mysql默认关闭， 需要在my.cnf中设置slow_query_log=1,并指定long_query_time = 2 ， 声明超过2秒的查询是“慢”的
修改后重启mysql， 可以在/var/lib/mysql找到慢查询日志

### profile
show profile可以在sql优化时了解时间在各个阶段耗时
可以在会话或者全局开启profiling， 然后查询所有语句的耗时， 或者指定语句各阶段耗时或者cpu占用。

### explain
使用explain或者desc命令获取mysql执行select的信息， 如连接过程

直接在select头上加上explain就行

相关字段有:
- possible_keys,可能用到的索引
- key, 实际使用的索引, null表示没有使用索引
- key_len长度
- rows扫描的数据行数
- type, 如何扫描的
	- all或者index, 全表/全索引扫描
	- 索引范围扫描, 从这个级别开始, 属于可用状态
	- ref, 非唯一索引扫描
	- eq_ref 唯一索引 多表
	- const, 结果只有一条的唯一索引
- extra
	- using filesort, group且需要排序, 可能得用文件排序,效率很低
	- using temporary, 用了临时表, 在order/group中, 最好避免
	- using index ,覆盖索引


#### 索引查询相关
使用using index condition, 可以检索使用了索引但是需要回表查询的数据
石笋using where; using index可以看不需要回表的

# 一张表的查询非常慢, 如何优化
- 使用explain分析
- 优化索引
	- 特别是避免索引失效
- 查询优化:
	- 不要select*, 
	- 尽量使用覆盖索引, 
	- 最好不要连表查询
	- 联表时, 最好是小表驱动大表, 被驱动表有索引
		- 这也就意味着,两层循环中,外层循环非常短,内层循环(主要是io数据页)非常快
- 分页优化, 对于limit n, y, 可以转成某个位置查询, 如id>xxx, limit10, 这样避免处理前面那些数据
- 表优化, 如拆分表, 垂直水平
- 缓存,如redis, 但要保证一致性
	- 对于读, 旁路缓存, 
	- 对于写, 先更新db, 然后删缓存
# 如果explain发现索引不正确, 如何干预
使用force index (idx_xxxx)在from子句后面