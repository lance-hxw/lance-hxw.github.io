# 事务特性：ACID
原子，一致，隔离，持久

# 隔离级别
默认，根据数据库
- ru：可以感知或者操作未提交事务
- rc：感知活操作已提交事务
- rr：避免不可重复读
- s：串行化
# 传播特性

调用方是不是事务？是的话怎么传播：
Propagation：
- REQUIRED：合并，如果已经有事务就加入，否则新建
- REQUIRES_NEW：总开新事务
- SUPPORTS：如果不存在事务，直接用非事务运行
- NOT_SUPPORED：存在事务就挂起，知道被调用方结束，继续执行事务
- MANDATORY：调用方不存在事务就抛出异常
- NEVER：存在事务就异常
- NESTED：运行嵌套事务，否则新建

# 如何理解Transaction超时时间timeout
默认-1， 具体根据sql决定，可以在@Transactional时指定timeout
其意义为：
- 事务开始（方法执行前），到最后一个statement执行完毕
# 默认回滚策略
只有RE时，才触发回滚，如果需要对所有异常回滚，需要指定：
```java
@Transactional(rollback=Exception.class)
```
此时所有Exception的子类都触发回滚