版本相关设定
由于zzzq，master/slave变成了source / replica
但是show master status 变成了：SHOW BINARY LOG STATUS
如果需要重新配置slave需要：reset REPLICA all;
# 在现有mysql主库上拓展为主从
## 允许停机
### 1. 备份主库
使用mysql dump， 将所有数据dump成一个sql文件
使用 --master-data=2 参数，将设置master的语句注释掉
- 这句的意思是，master-data这部分被禁用（1是在结果sql中再次执行
- 这个是deprecated， 应该用--source-data

```shell
docker exec -i mysql mysqldump -u root -p --all-databases > ./backup.sql
```

### 2. 检查主库是否开启binlog
复制就是监听binlog
配置应如下：
```ini
[mysqld]
server-id=1
log-bin=mysql-bin
binlog-format=ROW
```
### 3.停机
停app，停主库，更新配置
### 4.启动主库
配置复制用户
（测试环境：将主库放进同一个network
使用SHOW BINARY LOG STATUS查看binlog状态
- File：binlog.000006
- Position: 3666
### 5.启动从库
将sql在从库中执行，然后：
执行CHANGE SOURCE语句，然后启动从库
这里要指定binlog和position
```sql
CHANGE REPLICATION SOURCE TO  
  SOURCE_HOST='mysql',  -- 如果容器在同一网络，直接用容器名  
  SOURCE_USER='repl_slave_user_1',  
  SOURCE_PASSWORD='password',  
  SOURCE_LOG_FILE='mysql-bin.000006',  
  SOURCE_LOG_POS=3666;  
  
START REPLICA;


SHOW REPLICA STATUS
```

### 6. 测试复制


## 无停机（在线迁移
- 需要使用工具， 生成备份sql的时候给出binlog文件和postion
关键就是这个备份文件和binlog中记录的关系， 主要解决方案有：
- 直接上锁，备份，然后给出binlog位置
	- 使用mysqldump --master-data =2 
	- 输出例如: -- CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000123', MASTER_LOG_POS=4567;
- XtraBackup为在线备份设计，有更低的锁定要求
	- 得到备份文件后，可以解析出binlog file 和postion

# 使用ShardingSphere 配置主从读写分离
见[[配置读写分离]]