应该使用#
# \#：预编译占位符
\#{}，将传入的参数当做一个值并创建一个预编译语句
- mybatis会根据参数的java类型进行jdbc类型转换，若传一个字符串，mybatis会写上引号
- 可以防止sql注入，由于参数是值而不是字符串，所以不会被直接拼到sql中

具体使用：
```xml
<select id="getUserById" resultType = "User">
	SELECT * FROM users WHERE id = #{userId}
</select>
```
# $字符串替换
$符号是直接将参数替换到sql中， 这样非常非常不安全
但是可以实现一些非常动态的功能，需要综合考虑
