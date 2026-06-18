es将索引的生命周期分成 hot warm cold delete 四个阶段
分别对应 读写，只读，很少访问，不再需要 四种状态

es ILM可以方便的管理具体index的滚动，缩减和删除控制，提升集群性能

主要工作流程是， 为index指定每个阶段的条件（如index年龄， data大小， 状态）和要执行的操作

然后将策略绑定到index模板上， 新index会使用对应策略

es会根据策略， 定期检测index生命状态，并触发响应阶段操作

# 能做哪些操作

hot阶段， 即大量读写发生
- rollover ， 自动创建新索引并切换
- set_priority 设置索引优先级（影响集群恢复
- forcemerge 合并segment， 减少段数量
- shrink， 将多个分片合并

warm ， 即只有读时

- allocate， 迁移到指定节点
- forcemerge， shrink
- readonly， 直接设置成只读

cold， 只做归档
- allocate 到冷节点
- searchable_snapshot，将索引变成可搜索快照
- freeze，直接冻结索引

# es如何做到这些操作

在master节点上运行的index lifecycle management service 周期执行
其主要概念是
- 每个index与一个策略管理， 然后ILM追踪每个index状态
- ILM runner定期（默认10min）检查是否切换阶段
- 执行器：
	- ILM调用集群间api对相关index进行操作
	- 每个操作都是幂等的
- 持久化和恢复， 生命周期阶段和动作都保存，可以恢复


# es 如何将index分配到指定节点？

es不能感知磁盘，也不能感知节点性能，所以相关策略需要你自己定义

需要在每个es节点的yml中加自定义属性

然后在index的setting中指定存储的目标标签

！还可以直接设定节点的角色， 可以直接放进hot节点中， 方便后续分配

不过es可以感知磁盘水位线， 即占用率


# ES 怎么rollover？

## 别名+rollover
按规则滚动建立新index后， 将新index放到别名中去