zk的ephemeral node的生命周期与创建其的client session绑定, 当session结束, 这个临时节点自然就会删除

锁之类的都是临时节点, 所以都会被释放

锁一般设计成带过期时间的