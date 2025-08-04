java database connectivity , 是java程序访问数据库的标准接口, java程序不通过TCP连接数据库, 而是jdbc接口, 然后jdbc驱动实现对数据库的访问
- 所以pg和mysql要用不同的驱动
- jdbc接口是java标准库自带的, 数据库发行者根据jdbc接口提供自家的驱动
- 驱动一般也是java写的, 这一套东西(java程序, 接口, 驱动)都在jvm中
## 建立连接
- connection: 代表一个jdbc连接, 相当于一个java程序到数据库的(通常是tcp)连接, 创建一个connection, 需要URL, 用户名和口令
	- URL形如: jdbc:mysql://\<host>:\<port>//\<db_name>?key1=value1&key2=value2
```java
Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
...
conn.close();
```
connection最好放在try-with-resources块中
## jdbc CRUD: 使用`PreparedStatement`

### 查
- 建立连接
- 用connection对象的createStatement方法, 创建一个statement对象
- 用Statement对象的`executeQuery("select * From table_name")`传入SQL并执行, 用`ResultSet`引用这个结果集合
- 使用`ResultSet`的next方法读取结果
	- 注意, 一开始的时候当前行不是第一行, 要执行一次next, next判断有下一行才切换到可读行
- *注意*, 请不要在Statement中拼接字符串, 这会导致SQL注入漏洞
	- 比如你想在'+name+'中放一个名字, 并且在两端准备好了引号, 然后传进来一个bob' OR 'Alice, 让用户能直接控制逻辑
- 应该使用PreparedStatement, 这玩意更快且更安全, 他始终使用?当占位符, 并且是将(带占位符的sql, 数据)传给数据库, 保证了sql逻辑不会被篡改(除非数据库漏洞)
```java
String sql = "select * from user where login=? and pass=?"
PreparedStatement pStatement = conn.prepareStatement(sql); // 拿sql提前编译statement
pStatement.setObject(1,name);
pStatement.setObject(2,pass); 
...
```
使用PreparedStatement时, 需要先用一个带占位符的sql语句, 生成一个pstatement对象, 然后调用`setObject`对每个占位符设置值
然后调用pstatement的executeQuery()方法, 最后得到的还是一个ResultSet对象
### 增
#TODO 
### 改

### 删
## 数据类型对应关系:

|SQL数据类型|Java数据类型|
|---|---|
|BIT, BOOL|boolean|
|INTEGER|int|
|BIGINT|long|
|REAL|float|
|FLOAT, DOUBLE|double|
|CHAR, VARCHAR|String|
|DECIMAL|BigDecimal|
|DATE|java.sql.Date, LocalDate|
|TIME|java.sql.Time, LocalTime|
