面向切面编程, 本质上是一个代理模式, 主要是为了实现日志等操作，比如各种拦截器


## 1. Spring AOP实现：切点定位-定义切面功能

### 1.1 概念
- Aspect： 关注的一个切面
- JoinPoint：程序执行过程中的某些特定未知，就是切点所在未知
- 切点pointCut：用于匹配连接点的断言
	- 需要复用就定义出来， 不然就用切点表达式
- Advice：在切点处执行的代码，advice注解包括：
	- Around，before，After，AfterReturning，AfterThorwing
### 1.2 定义注解
```java
@Target（ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LogExecutionTime {

}
```
### 1.3 实现流程
对于一个业务服务xxService， 以基本的log功能为例

#### 1.3.1确定切点位置
使用切点表达式进行切点定位，注意切点定义和注解定位
#### 1.3.2使用Aspect注解， 定义一个切面类，使用Advice注解定义行为
```java
@Aspect
@Component
public class LoggingAspect{
	@Around
	@Before
	@After
}
```
#### 1.3.3在service的实现中使用应用切面
```java
@Service
public class xxServiceImpl implements xxService {
	@LogExecutionTime //使用注解定位
	@Override
	public User findById(Long id){
		return null;
	}
}
```

### 1.4 如何确定切点位置
两种方式(根据是否提前定义切点)
- 在Aspect类中，使用@Pointcut定义切点， 可以匹配大范围
	- 这东西的作用就是切点复用，如果只用一次就不用定义
- 在Aspect类中的Around等方法中，直接使用切点表达式
在通知注解中，可以结合二者，如：
```java
@Pointcut("execution(* com.example.service.*.*(..))")
public void serviceLayer() {}

@Target(ElementType.METHOD) @Retention(RetentionPolicy.RUNTIME) public @interface LogExecutionTime {}

@Around("serviceLayer()") // 切点

@Around("execution(* com.example.service.*.*(..))") //直接用

@Around("@annotation(com.example.LogExecutionTime)") //切入注解
```
其中定义切点位置的表达式称为切点表达式，最常用的exe格式为：
```java
execution([修饰符] 返回类型 [类的完全限定名] 方法名(参数列表) [throws  异常])
```
其中方括号部分可选， 其中：
- 修饰符部分是public等
- 返回类型，方法名和参数列表都是方法定义的一部分
	- 返回类型可以用\*通配
	- 方法名使用全部路径，每个部分都可以用通配符
		- service..\*.\*的意思是service和service的所有子包中的内容
	- 参数列表可以用..通配
		- 如果需要定义，写参数类型，如（String，int）
此外，还有如下表达式
- @annotation：匹配方法注解
- @within：匹配类注解中的所有方法，如@within("org...Service")
- @target: 类似within，但是在运行时动态检查类的注解
- within：匹配指定类型内的方法，如within(xxService)
- this: 匹配代理对象是指定类型的方法
- target
- args
- @args
- bean: 匹配指定名称Bean
一般来说：
- 需要匹配方法执行时，使用execution
- 需要匹配注解时，使用@annotation
- 需要匹配包/类时，使用within
- 需要匹配Bean时，使用bean
注意动态检查的表达式影响性能
不应该写一长串复杂表达式，而是分拆为小的切点
切点表达式可以使用布尔运算，&& || ！来组合切点表达式，注意优先级和括号
### 1.5 几类Advice
如果多个Advice作用与同一个切点，顺序为：
- @Around（开始）
- @Before
- 目标方法
- @Around（结束）
- @After
- @AfterReturning 或者 @AfterThrowing
### 1.6 Aspect类和Advice方法具体实现
接受JoinPoint参数，其成员有：
- MethodSignature := joinPoint.getSignature()
- methodName = signature.getName()
- args = joinPoint.getArgs() : 参数 
- target = joinPoint.getTarge() : 目标对象
- proxy = joinPoint.getThis() :  代理对象

ProceedingJoinPoint继承自JoinPoint， 具有更多功能
- 只能用于Around通知
- 特别功能：
	- result = pJoinPoint.proceed()
	- result = rJoinPoint.proceed(modifiedArgs)
- 可以完全控制目标方法的执行，可以修改参数和控制返回值
- 用于复杂的切点
```java
@Aspect
@Component
public class UserServiceAspect {
    // @Before - 前置通知：在目标方法执行前执行
    @Before("execution(* com.example.service.UserService.*(..))")
    public void beforeAdvice(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        Object[] args = joinPoint.getArgs();
        System.out.println("前置通知 - 方法: " + methodName + ", 参数: " + Arrays.toString(args));
    }

    // @After - 后置通知：在目标方法执行后执行（无论是否发生异常）
    @After("execution(* com.example.service.UserService.*(..))")
    public void afterAdvice(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("后置通知 - 方法: " + methodName + " 执行完成");
    }

    // @AfterReturning - 返回通知：在目标方法成功执行后执行
    @AfterReturning(
        pointcut = "execution(* com.example.service.UserService.getUserInfo(..))",
        returning = "result"
    )
    public void afterReturningAdvice(JoinPoint joinPoint, Object result) {
        System.out.println("返回通知 - 方法返回值: " + result);
    }

    // @AfterThrowing - 异常通知：在目标方法抛出异常后执行
    @AfterThrowing(
        pointcut = "execution(* com.example.service.UserService.*(..))",
        throwing = "ex"
    )
    public void afterThrowingAdvice(JoinPoint joinPoint, Exception ex) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("异常通知 - 方法: " + methodName + " 发生异常: " + ex.getMessage());
    }

    // @Around - 环绕通知：包围目标方法的执行
    @Around("execution(* com.example.service.UserService.*(..))")
    public Object aroundAdvice(ProceedingJoinPoint joinPoint) throws Throwable {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("环绕通知 - 方法执行前: " + methodName);
        
        try {
            // 执行目标方法
            Object result = joinPoint.proceed();
            System.out.println("环绕通知 - 方法执行后: " + methodName);
            return result;
        } catch (Exception e) {
            System.out.println("环绕通知 - 方法异常: " + methodName);
            throw e;
        }
    }

    // 自定义切点
    @Pointcut("execution(* com.example.service.UserService.*(..))")
    public void userServiceMethods() {}

    // 使用自定义切点的通知
    @Before("userServiceMethods()")
    public void beforeWithCustomPointcut(JoinPoint joinPoint) {
        System.out.println("使用自定义切点的前置通知");
    }
}
```