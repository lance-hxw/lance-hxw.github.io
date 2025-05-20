根据引入了什么starter，就自动配置什么
他进行依赖聚合，然后自动加载相关配置，比如starter-web， 就是依赖并自动配置一个Tomcat服务器

# 常见Starter
- -web：tomcat和springmvc
- -data-jpa：数据库访问，Hibernate， Spring data jpa
- -security：ss
- -test：Junit
- -actuator：监控和管理
- 可以自定义starter
# 一般会配置什么
- web
- 数据
- 自动加载配置文件（后续要手动配置到类里面，或者自动配置
- 日志系统
- ioc容器相关
- mq starter有的话
# 如何实现：Spring boot
- 通过ConditionalOnClass等条件注解， 检测Mysql驱动存在
- 然后激活DataSourceAutoConfiguration， jdbcxxx等自动配置类
- 自动配置类加载相关设置
# 自定义自动配置：
如在自己的RPC框架中
- 创建配置属性类 MyRpcProperties
- 创建自动配置类 MyRpcAutoConfiguration
- 注册自动配置类 在项目resources/META-INF/spring.factories中注册自动配置类：
	- org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
	- com.yourpackage.MyRpcAutoConfiguration
- 实现服务扫描和注册（如果需要扫描带有注解的类并将其设置为rpc服务）
	- 实现一个注解
	- 在自动配置中添加服务扫描功能
