# 应用程序 使用 专用的账号访问，而非root
如何创建用户并分配权限：
- 权限应该最小化
- 可以限制连接来源（如内网访问,即@字段
```java
CREATE USER 'app_user'@'%' INDENTIFIED BY 'your_password';

GRANT SELECT, INSERT, UPDATE, DELETE ON myapp_db.* TO 'app_user'@'%';
// 如果需要执行存储过程的权限
GRANT EXECUTE ON myapp_db.* TO 'app_user'@'%';

FLUSH PRIVILEGES;
```
如果需要管理员账号，可以GRANT ALL PRIVILEGES
如果需要只读场景，就只给SELECT

# 主从场景账号管理
## 主库需要设置复制账号
```sql
CREATE USER 'repl_user'@'%' IDENTIFIED BY 'your_password';
GRANT REPLICATION SLAVE ON *.* TO 'repl_user'@'%';
```
## 读写分离需要配置不同用途的账号
一个主库写入账号，在主库上用于读写
一个从库的只读账号
此外
- 从库应该是read_only
- 确保复制账号能在从库写，因为此时外部访问账号是只读的（或者数据库设置只读了
	- 这个复制账号也需要REPLICATION SLAVE权限