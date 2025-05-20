 - 注意, pg中, user是保留字, 使用时, 不能在注解中写, 需要去xml中写
## 异常处理
pg中只定义了一个PSQLException, 继承了java.sql.SQLException, 代码中只能处理SQLException的错误, 如果需要判断具体错误类型, 需要使用sqlstate等信息
如:
```java
try (){
} catch (SQLException){
	if (ex.getSQLState().equals("23505")){ // unique
		...
	}else {
		ex.printStackTrace();
	}
}
```
其中, SQLException有成员:
```java
SQLState: String
vendorCode: int
next: SQLException
netUpdataer ...
serialversionUID: long

```