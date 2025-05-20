容器是为特定组件运行提供必要支持的一个软件环境, 如docker是linux进程容器, 而tomcat是一个servlet容器, 一般来说, 容器除了要能支持程序运行, 还需要提供一类容器需要的底层功能, 如servlet容器需要提供tcp链接等http功能.
java早期ejb容器最重要的就是提供了声明式事务服务, 简化事务处理. 而spring就是为了取代ejb而生. 他提供了IoC容器, 管理所有javaBean组件, 提供的底层服务包括:
- 生命周期管理, 配置和组装
- AOP
- 声明式事务
## 什么是IoC
[[依赖注入DI和控制反转IoC]]
控制反转, 那就要看看朴素的"控制": 当一个组件需要另一个组件的功能的时候, 就new-持有
这样非常直观, 但是缺点很多:
- 如果一个组件需要一个实例, 就要会创建这个实例
 - 大量的实例化, 这个过程其实很复杂
 - 实例不能复用, 而且多个数据操纵实例会涉及复杂的处理, 这需要额外再实现一个组件, 而且这种情况下, 不好复用, 因为是在组件内部new的
 - 组件需要销毁时, 无法监控组件实例依赖情况, 不敢销毁
 - 这种复杂网状依赖非常复杂, 而且越来越复杂
 那么要降低系统复杂程度, 就需要解决:
> - 谁创建组件
> - 如何根据依赖关系组装
> - 如何按照依赖关系销毁
## IoC容器负责创建组件
IoC知道如何实例化任何组件, 所以就让IoC容器去创建组件, 并让IoC容器持有, 由于所有实例(依赖)都在IoC容器中, 所以当其他组件中需要依赖时, 就需要"注入"机制(就是接受一个实参), 这个可以用set方法, 或者构造函数等实现.
这样实现完可以发现, 其实虽然我们面向Spring的IoC容器编程 , 但是过程只是在进行java代码的解耦合, 程序不知道自己在IoC中运行, 这种设计称为无侵入容器, 优点是可以不依赖ioc容器中运行, 可以直接写本地测试, 单独组装配置.
## 装配方式
### XML文件用于组装
在Spring的IoC容器中, 所有组件都是javaBean, 配置一个组件就是配置一个bean
最简单的是通过XML文件配置组装方式, 如:
```xml
<beans>
	<bean id="dep1" class="Dependency" />
	<bean id="myServer" class="Server">
		<property name="dep1" ref="dep1"> # 是通过setDep1 注入的
	</bean>
</beans>
```
src/main下有应该有java和resources两个目录, 其中java是类文件, resources中放xml文件进行组装
Spring容器读取xml文件通过反射组装组件.
如果不只是注入Bean, 需要注入boolean, int等数据类型, 用"value"注入:
```xml
<bean id="myData" class="xxx.xxx.xxx.Data">
	<property name="url" value="www.xxx.xxx" />
	<property name="username" value="usr" />
	<property name="password" value="123456" />
</bean>
```
使用时, 需要创建一个IoC容器实例, 然后加载配置文件, 让Spring进行实例化, 并装配所有bean
```java
ApplicationContext context=new ClassPathXmlApplicationContext("application.xml");
```
然后就可以从Spring中取出来用bean了:
```java
xxx.Data myData=context.getBean(xxx.Data.class)
```
这其中, ApplicationContext就是Spring的IoC容器接口, 有很多实现类, 这里是从xmlpath中查找配置的类.
获取ApplicationContext的实例, 就获得了IoC容器的引用, 然后就可以根据bean id或者Bean的类型获取一个bean的引用

Spring还有另一个IoC容器: BeanFactory, 听起来非常直观, 和ApplicationContext的区别是, BeanFactory是按需创建, 即第一次获取时才创建, 而A是一次性创建所有Bean, 事实上, Application继承自BeanFactory, 并提供额外功能, 所以一般直接用A

### Annotation配置
写xml配置, 你写一点代码就需要同步更新xml, 太离谱了. annotation是更轻量化的方案. Spring会自动扫描bean然后组装, 不需要xml文件
用 @Component注解定义bean, 用@Autowired注解指定注入位置, 可以在set上写, 也可以直接写在字段上, 甚至构造方法里面的形参上(注意Autowired一对一)
一般@Autowired字段写在package权限的字段上, 便于测试
最后写一个AppConfig类当启动器, 其中把自己传进去获取AppC, 然后直接根据类取bean, 在这个类前面加上@Configuration和@ComponentScan注解

这样我们只需要把AppConfig放在底层包里, 然后保证所有用到的bean都在包中就行
但是要注意(不算缺点):
- *这种方式需要设计好包的结构*
- 有一定侵入性, 需要代码写好注解
- 不在包里的bean需要额外处理 [[#第三方bean]]
## 特殊bean
### Scope
一般的bean在调用getBean(class)的时候, 返回的是一个Singleton, 如果需要每次返回一个新的实例, 那么需要用原型(prototype), 此时需要额外加一个@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYE)控制特殊的生命周期
这个就没啥意义, 根本不存在ioc了, 也不需要di
### 注入List
如果我用一个接口A写了若干实现类, 那么当我写了
```java
@Autowired
List<A> aList; #注入后怎么操作在代码中实现
```
此时, 所有A类型的Bean都会被注入到list中去, 新增也会被直接注入
如果需要指定bean的顺序, 需要在bean上加上@Order(n)注释, 如果n值重复了可能导致顺序不确定.
### 可选注入
一般的, 如果标记了一个@Autowired, 如果spring没找到对应的bean, 就会报错, 此时可以加一个required=false参数, 实现可选, 一般用于默认值场景
### 第三方bean
自己在@Configuration类中编写一个Java**方法**创建并返回这个Bean, 注意用@Bean注解
@Configuration类的一个意义就在于, 会把Config类中的bean定义也注入到上下文中去, 不写这个注释会影响这种情况.
```java
@Configuration
@ComponentScan
public class AppConfig{
	@Bean
	ThirdPartyClass createTPC(){ # 注意这里是返回一个bean实例, spring会扫描@bean方法并调用一次, 此时这些bean还是单例
		return ThirdPartyClass(xxx);
	}
}
``` 
如果要用第三方原型类呢, 其实这个不好, 用原型是脱离Spring容器的, 这不好
### 初始化和销毁
使用@PostConstruct和@PreDestroy注解标记init和shutdown方法, 此时bean的生命周期是;
- Spring调用构造方法创建bean实例
- 根据Autowired注解进行注入
- 调用标记有PostConstruct注解的方法进行初始化
- ...
- 调用PreDestroy注解的方法
注意这个过程spring只看注解, 不关心具体的方法名称
### 别名
如果我们需要对一个类型的Bean创建多个实例, 但是又不想让他每次都返回新实例
此时一个显然的方法是使用一个接口弄多个实现类, 但如果需要直接复用代码, 就需要别名
如:
```java
@Configuration
@ComponentScan
public class AppConfig{
	@Bean("z")
	Data createDataZ()...
	@Bean
	@Qualifier("B")
	Data createDataB()...
}
```
这样我们就有了拥有不同bean id(spring中实例的唯一标志符)的两个相同类型的bean, 但是当我们使用class注入的时候, 还是会报错, 有两个方法:
- 使用@Qualifier("name")在注入的地方指定注入的具体bean实例
- 在Bean定义处使用@Primary注解, 指定主bean, 如果没有使用id注入, 就注入主bean
### FactoryBean
这个东西正在被@Bean取代, 但是要注意, 当使用时, 一个继承了FactoryBean\<class\>的Bean, Spring不仅会实例化工厂, 而且会调用getObject()接口, 在注入时, 注入工厂产生的FactoryBean实例, 而不是注入一个工厂. 这种工厂产出的bean一般命名成xxFactoryBean

## 使用Resource中的文件
可以使用@Value()注入路径再读取
如:
```java
@Value("file_path")
private Resource resource;

@PostConstruct
public xxxxx xxx {
	// some io op
}
```
## 注入配置
可以用value注入配置文件, 但是也可直接用@PropertySource自动读取配置文件, 然后直接注入配置文件中的值:
```java
@Configuration
@ComponentScan
@PropertySource("app.properties")
public class AppConfig{
	@Value("${app.data:Z}")
	String data
}
```
注入语法是:
- "${app.data}": 读取key为app.data的value, 如果这个key不存在, 就报错
- "${app.data:Z}": 读取key为app.dta的value, 如果key不存在, 就使用默认值Z
这里这个app.properties是一个存放在resources下的配置文件, 一般用=连接键值对, 一行一对

另一个注入配置的方案是:用一个简单的javaBean获取所有配置(配置写在代码中), 然后让spring扫描并加入, 但这样是硬编码的
```java
@Component
public class XxxConfig{
	@Value("mima")
	private String password;

	@Value("zhang hao")
	private String zhanghao;
}
```
然后在需要注入的地方, 使用#{XxxConfig.password}注入
```java
@Component
public class XxxService{
	@Value("#{XxxConfig.password}")
	private String myPassword;
}
```
这个#是从bean中读成员 调用getPassword方法

## 条件装配
Spring中提供了@Profile来根据不同环境决定是否创建bean, 如设置了test环境, 就可以写"test"和"!test", 如果要指定多个Profile, 可以用{"test","dev"}
还可以直接用@Conditional来决定, 可以传一个Condition实现类进去如:
```java
public class MyCondition implements Condition {
	public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
        return "true".equalsIgnoreCase(System.getenv("smtp"));
    }
}

@Component
@Conditional(MyCondition.class)
public class xxx ...
```
SpringBoot中还有更多方便的条件注解, 如:
> @ConditionalOnProperty(name="app.data", havingValue="true) // 如果配置文件存在app.data
> @ConditionalOnClass(name="xxxx") // 如果当前classpath中存在类, 就创建
