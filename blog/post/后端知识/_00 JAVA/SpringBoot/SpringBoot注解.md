@SpringBootApplication 是SpringBoot中最重要的注解, 他包括了:
- @EnableAutoConfiguration: 启用条件装配
	- 通过一系列条件注解, 如MissingBean, 来自动配置诸如javax.sql.DataSource等Bean接口的实例
	- 诸如ds和redis等配置, 并不需要自己写configuration, 这些starter自己就配置了一份
- @ComponentScan: 自动扫描和发现标记为Spring组件的类, 包括
	- @Component: 标志Bean组件, 但不带有特殊分类, 带有他的类的实例可以等价config类中的@Bean方法创建的实例
	- @Service
	- @Repository
	- @Controller
- @SpringConfiguration

## Ref.
[Spring Boot自动配置的原理简介以及@Conditional条件注解_springboot根据配置控制 主启动类上的某一个注解是否开启-CSDN博客](https://blog.csdn.net/weixin_43767015/article/details/118178404)