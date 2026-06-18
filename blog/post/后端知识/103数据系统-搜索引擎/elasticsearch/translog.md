es的事务日志， 类似binlog，但又是WAL

当一个记录写入es， 先写translog，作为持久化保证

同时translog也可以用于主从复制

并可以用于快速恢复