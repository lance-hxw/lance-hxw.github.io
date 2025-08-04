- mybatis对于集合类返回默认非null, 而是空表
	- 但是对于单个对象, 还是会返回null的, 这个需要判断.
## 注解方式和XML方式
这两种都可以, xml更易维护, 注解更方便
注解：
```java
@Insert("<script>INSERT INTO user(name) VALUES " +
        "<foreach collection='list' item='user' separator=','>" +
        "(#{user.name})" +
        "</foreach></script>")
@Options(useGeneratedKeys = true, keyProperty = "id")
int batchInsert(List<User> users);
```
xml：
```java
<insert id="batchInsert" useGeneratedKeys="true" keyProperty="id">
    INSERT INTO user(name) VALUES
    <foreach collection="list" item="user" separator=",">
        (#{user.name})
    </foreach>
</insert>
```

## mybatis 注解
```java
# 映射相关
@Select,@Insert,@Update,@Delete
// 还有动态映射的xxxProvider
# 结果映射
@Result, @Results, @ResultMap, @One, @Many
# 缓存
@CacheNamespace, @CacheNamespaceRef
# 参数相关
@Param, @MapKey
# 类型处理器相关
@MappedTypes, @MappedJdbcTypes
# Mapper接口相关
@Mapper, @Repository 持久层组件
# 常用注解
- @Options, 配置选项
- @Flush, 刷新缓存
- @Lang, 语言驱动
```

## parameterType

### 给写入方法传入参数
- 传入单个简单类型， 直接访问参数名
	- xml指定为int之类的类型
- 传入多个简单类型， 自动封装为map， 需要指定key名
	- xml指定为map
- 传单个自定义对象， 展开为属性名
	- xml指定为对象
- 传List等数据结构， 不展开
	- xml指定为list等数据结构
- 多个自定义类型， 使用map
	- xml指定为map
## resultType
- 如果需要特别的关系处理, 可以在xml中定义resultMap 并在sql中使用