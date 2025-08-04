[[SQL 事务]]
sql有acid特性, 所以很多操作必须依赖sql事务保证安全
在jdbc中使用事务, 就是将多个sql放在一个事务中执行, 一般如下
```java
Connection conn = openConnection();
try {
    // 关闭自动提交:
    conn.setAutoCommit(false);
    // 执行多条SQL语句:
    insert(); update(); delete();
    // 提交事务:
    conn.commit();
} catch (SQLException e) {
    // 回滚事务:
    conn.rollback();
} finally {
    conn.setAutoCommit(true);
    conn.close();
}
```
其中关键是关闭自动提交, 用多条语句拼凑形成事务后, 再用commit, 由于事务可能失败, 所以失败后要处理sql异常, 此时需要rollback, 结束时, 还要把自动提交再开开, 最后释放资源

这也意味着, connection每次运行其实都是将一个sql当一个事务运行

如果不修改事务隔离级别, 会使用数据库默认的级别, mysql默认repateable_read