```java
<insert id="insertUser" parameterType="com.example.User" useGeneratedKeys="true" keyProperty="id">
    INSERT INTO user (name) 
    VALUES (#{name})
</insert>
```
- `useGeneratedKeys="true"` - 让mybatis将id返回给java实体类
- `keyProperty="id"` - 指定将生成的主键值注入到参数对象的哪个属性
### 实现原理
- 在执行insert前， 实例化一个keygenerator实例类
- 使用JDBC的geGeneratedKeys获取主键， 在插入后调用并通过反射设置到对应属性
```java
MetaObject metaParam = MetaObject.forObject(parameter); metaParam.setValue(keyProperty, rs.getLong(1));
```
### 其他方式
- 手动生成的id不用多说
- oracle等不支持自增主键的， 需要用selectKey方法去拿