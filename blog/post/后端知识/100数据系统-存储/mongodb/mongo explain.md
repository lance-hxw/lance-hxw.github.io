对于一个查询的结果, 其主要属性是:
- 命名空间, db.col
- 查询条件
- winningPlan
- rejectedPlans

# 一个mongo的plan

一个执行计划是一个复杂的树状结构, 描述查询优化器的查询执行路径, 每个计划由多个stage组成, 按树形排列, 每个阶段表示一个操作
如: 索引扫描, 文档获取, 排序等, 并补充相关元信息

一个例子:
- root stage: 如, LIMIT, PROJECTION,  SORT, 这个是最后执行的
- inputstages, 多个子阶段
- 每个阶段:
	- stage: 阶段名, 如IXSCAN索引扫描, FETCH查文档, SORT
	- 阶段相关参数等
	- 诊断字段
		- indexBounds, 如果有\[MinKey,MaxKey]说明是全索引扫(或者二级索引局部全扫)
		- SORT, 有usedMemory等字段标记内存使用情况
- 拒绝计划可以用于对比

# 需要留意的点

- COLLSCAN: 全表扫描
- 大内存SORT , 大于100MB就很大了
- 索引有效性, 检查indexBounds, 检查isPartial是否覆盖查询条件(部分索引)
- 阶段顺序优化, LIMIT应该尽可能早出现, 减少后续处理
- FETCH前应该有高效IXSCAN, 压缩范围(不一定追求覆盖)
- 索引覆盖:
	- 如果PROJECTION直接接上IXSCAN, 没有FETCH表示不用回表
# 对于增删的模拟explain

新版本直接不准分析了, 会出错

可以模拟插入的时候的查