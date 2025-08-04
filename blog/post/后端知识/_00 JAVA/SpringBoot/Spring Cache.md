
在maven中配置后, 会自动装配redis进去
常用注解
 - @EnableCaching, 开启缓存注解
 - @Cacheable, 在方法执行前检查缓存中的数据, 并支持将返回值写缓存
 - @CachePut 将返回值写缓存(不取)
 - @CacheEvict 删若干缓存
	 - 在方法执行完后删除key对应的缓存
	 - 如果想把整个目录下缓存都删掉, 设置allEntries=True, 不要设置key值
		 - 注意, 由于update可能导致两个或更多的变动, 所以最好全清
		 - 好吧只要修改最好都是全清, 这样开销不大, bug最少
Spring Cache是基于代理实现的, 所以在"缓存存在直接取"这种情况下, 实际方法并不会被运行
## 使用
首先在app上加上EnableCaching, 然后在需要的地方进行cache操作

```java
// cacheNames 是分区, key是动态key
	// #user是函数参数定位
// redis最终key是 cacheNames::key
@CachePut(cacheNames = "userCache", key = "#user.id")
public User create(User user){
	userMapper.insert(user);
	return user;
}
余类推
```

## QA
### 为什么用两个冒号
- 更加通用, 不和自己用的key混淆
- 实现是在SpringCache中, 实现了一个函数式接口CacheKeyPrefix
	- 并提供了一个静态默认实现, 就是这样的
	- 可以配置给进去一个自己的实现
### 自动装配
- 一般来说, 你在xml中配置好, 就可以自动装配redis
	- Spring Cache会装配RedisCacheManager类和RedisTemplate
- 也可以手动写这个Manager类和Template
	- 如果你需要特殊的配置
	- 或者同时使用Spring Cache和直接操作redis
- 其中:
	- Template是任何redis操作都需要的, 包括手动使用redis
	- SpringCache是依赖于Manager的, 也需要一个Template
### Evict时间
- 默认地, CacheEvict创建代理, 在方法修改数据后删除缓存.
- 但是, 可以使用beforeInvocation=true参数, 实现在运行方法前就删除缓存
	- 注意, 这样不会双重删除, 高并发情况下会出bug
- 也可以自定义逻辑手动处理
- 或者也可以写一个切面, 然后直接匹配CacheEvict这个注解
	- 从注解中获取cacheName和key, 然后在before中手动处理
	- 这样就是双删了, 你的切面生效一次, CacheEvict再来一次
	