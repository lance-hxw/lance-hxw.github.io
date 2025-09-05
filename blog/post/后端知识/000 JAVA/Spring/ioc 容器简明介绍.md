# spring 两种ioc容器

## BeanFactory
基础的 容器接口

## ApplicationContext
继承BeanFactory， 提供更多企业级支持， 如AOP， 事件发布， 国际化等。


# spring 自动装载过程

## 容器初始化阶段
解析配置文件/注解， 构建每个Bean对应的BeanDefinition对象， 注册到BeanDefinitionRegistry中

## Bean实例化

先执行BeanFactoryPostProcessor预处理， 对beanDefinition进行一定修改

然后使用反射机制创建Bean实例， 可以调用构造函数， 工厂方法进行。

## 属性填充

通过setter/autowired注入依赖

## aware接口回调

如果这个Bean实现了BeanNameAware等， 会回调， 感知容器环境

## beanPostProcessor 初始化预处理

## 初始化
实现了InitializingBean接口， 就会在属性设置后执行初始化方法

## 后置处理


此时调用beanPostProcessor的postProcessAfterInitialization方法， 完成最终处理， 并创建AOP代理

# 自动装载方式

方式：
- 构造函数
- setter
- 字段上写autowired
- 方法上注入

相关注解：
- autowired， 按类型自动装载
- qualifier，制定bean
- resource， 按名称和类型装载
- value：注入特定值
- componet， service，respository ，controller， 标记组件类

## autowired和resource的区别

a是spring的， r是java ee的

a是默认按类型， 如果同类型有多个， 需要制定
r是按名称， 如果找不到，再按类型

a可以在多个地方使用，功能更强大，可以设置required，允许不装配
r用于字段和setter， 不能放构造函数上

```java
@Service
public class UserService {
    @Autowired
    private UserDao userDao;
    
    @Autowired
    @Qualifier("redisCache")
    private CacheService cacheService;
}
@Service
public class UserService {
    @Resource
    private UserDao userDao; // 按字段名userDao查找Bean
    
    @Resource(name = "redisCache")
    private CacheService cacheService; // 按指定名称查找
}

```

# autowird具体使用

```java
@Service
public class UserService {
    private UserDao userDao;
    
    @Autowired
    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
}
```

在setter和构造函数上用， 可以实现更灵活的初始化逻辑