## 自动提交
如果使用sqlSessionFactory.openSession获取一个session，默认是autoCommit = false
此时需要在最后显式commit
如果用openSession(true)， 就是自动提交的， 此时每条sql操作立即提交

## 与Spring 声明式事务
如果开了， 那一般会用spring提供的sqlSessiontemplate代理对象，此时Spring会在最后自动提交，将整个方法封装成一个事务，并自动回滚