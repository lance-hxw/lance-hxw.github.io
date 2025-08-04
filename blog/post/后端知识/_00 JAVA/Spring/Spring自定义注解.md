一个典型例子如下，包含了四种基本元注解：
```java
@Target({ElementType.TYPE, ElementType.METHOD}) // 可用目标
@Retention(RetentionPolicy.RUNTIME) //保留策略
@Documented //生成文档
@Component //spring bean
public @interface LogExecutionTime {

}

```
#TODO 

## 成员
注解中可以包含若干成员变量， 不能有成员方法，如：
```
String value() default "";
```

## Retention

有三种保留策略
- SOURCE 源码级别， 编译时就丢弃， 不会写入class文件
	- 是用于编译时检查，ide/编码工具，代码生成工具
	- 开发时使用
- CLASS 字节码级别，不会被jvm加载到运行时，默认策略
	- 用于字节码级别的编译和检查工具
	- 编译时实现AOP
- RUNTIME 全程保留
	- 可以通过反射（这个要从jvm取）获取
	- 性能开销大
	- 可以动态代理