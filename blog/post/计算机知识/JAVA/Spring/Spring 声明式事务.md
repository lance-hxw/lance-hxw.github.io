spring提供了一个PlatformTransactionManager表示事务管理器, 所有事务都是他管理, 一个事务用TransactionStatus表示.
- 这个Platform...是为了同时支持javaEE中的jdbc事务和分布式事务jta
- 使用jdbc事务时,需要自己定义一个DataSourceTransactionManager, 注入到PlatformTransactionManager的实例中.
但是使用代码去写事务还是麻烦, 更方便的是声明式事务, 只需要在AppConfig中装配一个PlatformTransactionManager, 然后再用@EnableTransactionManagement来开启声明式事务(在AppConfig上).
然后, 在需要事务支持的地方, 使用@Transactional注解, 或者直接在某个bean上加, 这样其所有**public**方法都有事务支持.
- spring支持声明式事务的方法, 是AOP代理
## 使用Transactional时发生了什么
一个具有声明事务支持的方法中的所有数据库操作会被当做一个事务来处理, spring会检测其中的任何数据库操作.
包括DataSource的任何操作, 或者Spring提供的任何工具, 如JDBCTemplate


## 何时触发回滚：，如果方法抛出未检查异常（RuntimeException及其子类），Spring会自动回滚事务
## 回滚什么：数据库数据
