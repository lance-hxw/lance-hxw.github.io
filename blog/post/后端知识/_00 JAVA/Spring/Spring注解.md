## @Configuration: 标识一个配置类
- 通知IoC容器, 处理这个类中的@Bean注解, 
- 可以用于
	- 一个功能需要的配置
	- 一个功能需要的额外Bean的实例化过程
## @Service: 服务层组件
- 通知IoC容器, 这是一个Bean
-------
- @Configuration的作用: 标识一个Spring的配置类, 可以代替xml文件配置, 这个在配置应用是好用, 但是不能代替xml文件配置
	- 他的主要作用是告诉spring这个类里也定义了一些bean, 要加载, 并且能注入别的地方
- @ConfigurationProperties("storeage.local"), 这样就可以从配置文件中读取这个项的所有子项然后注入到这个类中
	- 注意保持成员和配置项同名
- @RequestBody处理json, 在处理Restfuiapi时, 将http请求体中的数据绑定到方法的参数上, 即将json或者xml转换成java对象

# Resource和Autowired，Qulifier， Bean， Primary

都用于bean注入， 都可以在字段上或者setter上，写字段上就不用setter
@Resource不是Spring的，是javax.annotation.Resource
不过Spring支持用这个注入
## autowired是byType装配对象，需要结合Qualifier才能byName
如果允许null，需要设置required
如果byname，需要结合@Qualifier（name）
如果有多个candidate，没有Qualifier或者Primary时，会用对象名作为最后的fallback
- primary在定义时使用，指定最高优先级，多个会抛出异常
```java
定义时
- 定义单独bean类：使用@Component("name")
- 配置类导入：
	- @Bean
	- @Qualifier("name"), 联合使用
- 但是其实直接@Bean(name = "abc") 就好了

注入时
@Autowired
@Qualifier("user")
private SpringSecurityManager aa;

@Resource(name = "user")
private A aa;
```

## Resource默认是byName，共有两个属性，name和type
即需要指定name，如果什么都没指定，就byName，找不到就回退一个原始类型

# 如何从xml中导入bean
\<bean...这种
加载，刷新。。。

#TODO 动态加载技术

# 