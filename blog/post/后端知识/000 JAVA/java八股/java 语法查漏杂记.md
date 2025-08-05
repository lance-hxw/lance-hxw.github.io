- java中有一个Unsafe对象, 是对操作系统底层的访问, 一般不访问, 有安全隐患.
- 相比与java SE, java EE是在SE上的扩展, 提供企业级和分布式应用, 整合了一系列企业应用的规范和API, 用于支持复杂大规模系统
- 一个class名XxxConfig的Bean, 在Spring中的默认bean名字是xxxConfig, 除非用@Qualifier("name")指定别名 #Spring
- classpath: java应用程序在运行时查找类文件和资源的路径, 指示jvm和spring如何加载文件, 一般指的是src/main/...等路径, 也会被maven等管理.
- java中的var, 可以自动推断变量类型, 但是只能用于局部变量.
- 任何一个只有一个抽象方法的类（即 **函数式接口**）都可以使用一个具有匹配方法签名的方法引用来赋值。Java 编译器会自动进行方法签名的匹配检查，确保方法引用能够正确替代函数式接口的抽象方法。
- == 是地址比较
	- 在字符串中，equals默认内容比较
	- 在其他类型中，如果没重写，二者等价
- 逃逸分析和stack中的对象
	- 是jvm优化,用于判断对象作用于,决定是否优化对象分配方法
	- 在JIT阶段分析对象作用于,判断是否escape出当前方法或者线程
	- 如果不逃逸,就可能在stack中进行标量替换.
- java实例中的receiver:
	- 标识谁在调用这个方法
	- 类型:
		- 隐式: this
		- 显式: 传入this
	- 作用域
		- 每个静态方法都有一个隐式receiver
	- lambda表达式中:
		- 可以用this直接捕获外部类的this
	- 内部类中:
		- 使用Outer.this捕获外部类this
	- 方法引用中:
		- 绑定: 对应实例
		- 不绑定: 需要动态指定
- 虚假唤醒
	- 操作系统错误唤醒或者被中断，并不是真的让线程开始执行，而是应该去世
## 拷贝
浅拷贝就是只创建一个指定对象
深拷贝是对这个对象中依赖的所有对象都拷贝, 即递归拷贝
 - 实现深拷贝(这个概念,而不是java具体语法):
	 - 实现cloneable接口,并重写clone方法,并在其中通过递归克隆引用字段实现, 这个链路上所有类都有clone
	 - 使用序列化, 要求所有成员都实现serializable
	 - 
## 泛型
例子:
```java
package com.sky.result;  
  
import lombok.Data;  
  
import java.io.Serializable;  
  
/**  
 * 后端统一返回结果  
 * @param <T>  
 */  
@Data  // 是Lombok注释, 可以自动生成getset
public class Result<T> implements Serializable {  
  
    private Integer code; //编码：1成功，0和其它数字为失败  
    private String msg; //错误信息  
    private T data; //数据  
  
    public static <T> Result<T> success() {  
        Result<T> result = new Result<T>();  
        result.code = 1;  
        return result;  
    }  
  
    public static <T> Result<T> success(T object) {  
        Result<T> result = new Result<T>();  
        result.data = object;  
        result.code = 1;  
        return result;  
    }  
  
    public static <T> Result<T> error(String msg) {  
        Result result = new Result();  
        result.msg = msg;  
        result.code = 0;  
        return result;  
    }  
  
}
```
定义了一个泛型类, 可以处理多种数据类型, 且可序列化
- 其中包含两个固定字段和一个泛型字段, 并提供三种类方法,用于给成员字段赋值.

泛型定义中，可以用extends限定T必须是某个类的子类，或者实现特定接口，可以用&间隔来指定多个接口，但是父类不能指定多个
泛型定义后，使用时需要指定类型，这样就避免了强制类型转换，更加安全，编译器会进行类型检查。
## try-with-resources
```java
try(ResourceType resource = new ResourceType()){
	//
}catch(Exception e){
	//
}
```
原理是, `ResourceType`实现了`java.lang.AutoCloseable`接口, java会在try块结束的时候调用close()方法释放资源
常见的实现了`AutoCloseable`接口的类有:
- 文件类, 如写流, 读流等
- 数据库类, 如Connection
- 网络类
- 其他IO类
可见, 主要是IO类资源

## 数据结构
### List<>
- add(ind, obj), 在0位置插入obj实例

## 流式处理 Stream API
如:
```java
return dishList.stream()
				.map(this::convertToDishVO) // 使用流式处理和映射方法 .collect(Collectors.toList());
```
进行流式处理, 需要先创建一个流对象, 如:
- list.stream()
然后进行中间操作:
- filter()
- map
- sorted
- distinct
终端操作, 这里会触发流的执行, 返回具体结果
- 收集, .collect(Collectors.toList()) , 转集合
- .forEach()
- .count(), .sum(), .max()
例子:
```java
List<User> users = Arrays.asList(
    new User("Alice", 20),
    new User("Bob", 17),
    new User("Charlie", 22)
);

List<String> names = users.stream()
    .filter(user -> user.getAge() > 18) // 过滤出年龄大于 18 的用户
    .map(User::getName)                // 提取用户的姓名
    .collect(Collectors.toList());    // 收集结果为 List

System.out.println(names); // 输出：[Alice, Charlie]

```
### 并行流
ParallelStream可以将源数据分成多个子流对象多线程处理后再合并，底层是fork/join池，对于cpu密集型数据处理，可以使用
## 方法引用

方法引用是对metaspace中，方法字节码的引用，但他：
- 不是对象
- 可以在被传入函数式接口时变成函数式接口实例，即成为对象
- 在使用时，生成一个方法句柄指向方法字节码
	- 可能用lambda工厂实现一个lambda对象通过invokedynamic绑定这个句柄
	- invokeddynamic用于动态绑定方法运行的字节码
		- 被用于lambda和方法引用。

lambda：
- 本身就是对象，也可以被转成函数式接口实例

## 类
- 类中, 使用this访问类
	- 如果没有歧义可以省略this
- 静态的用类名
- super访问父类实例
- 类中代码块
	- 静态代码块
		- 用于操作静态变量或者一次性的操作， 用static修饰
	- 构造代码块
		- 每次实例化时执行相同的初始化过程
		- 便于简化多个不同的构造方法
		- 构造代码块在构造方法前执行
	- 实例代码块
		- 即构造代码块
- 非静态内部类在生成其构造方法时,自动将外部类的实例作为参数传入,所以可以直接访问外部类实例的方法
	- 非静态内部类不能定义静态成员,即类成员
- 静态内部类不依赖与外部类的实例,只能访问外部类的静态成员,其他成员需要实例化外部类
	- 静态内部类可以独立实例化,如被外部类静态方法获取
	- 静态内部类也可以直接用外部类名来访问,如可以这样实例化: CLASS_A.static_classname
- 匿名内部类：用于创建实现runnable的接口，或者特定回调对象
	- 生命周期：会被用在回调或者其他线程中，导致其与局部变量生命周期不一致，故必须让局部变量是final的，然后capture局部变量的副本后续使用，这个capture的过程发生在实例化时。
```java
可以实现接口或者继承，但只能重写一个方法，如：
interface Animal{
	void sound();
}
...
Animal animal = new Animal(){
	public void sound(){
		System.out.println("fword");
	}
}
...
```
## 接口
接口方法默认是abstract+public的，接口中的变量默认是final
## 初始化
- 局部变量没有默认初始化
	- 数组还是会初始化
- 成员变量会默认初始化
## 修饰词

- final： 修饰类，变量，方法，表示不可继承，不可修改， 不可重写
- abstract： 抽象方法， 抽象类，接口默认是抽象的
- default： 在接口中可以实现默认方法
- static： 静态代码块，静态方法，静态成员
- private： 类内访问
- protected：允许在子类中访问
- public：公开
- synchronized: [[synchronized]]修饰方法或者代码块，表示同步，只能有一个线程执行
	- 可以加锁一个特定对象，即synchronized（obj），类内代码块和方法中，默认锁当前对象，静态方法或者静态代码块中，默认锁类，其他线程不能进入该代码块或者方法。
	- 原理：
		- 运行同步代码块时，需要锁
		- 自动进行锁排队，避免思索，
- volatile：变量，表示可能被多个线程修改，并保持修改多线程可见，通过禁止指令重排
- native：调用外部的本地代码，一个native修饰的方法，需要生成一个JNI文件头，包含所有native方法的原型，然后编译本地代码成dll/so，然后用System.loadLibrary加载

### 修饰词默认顺序
- 访问修饰， 如public
- 静态修饰， static
- 最终修饰， final
- 同步修饰，synchronized
- 本地修饰， native
- 抽象： abstract
- 严格： strictfp
## 局部代码块
类似类内代码块， 局部代码块可以在方法中使用，限定其中的局部变量的命名空间，并可以被同步修饰
此时可以把this锁了

## 注解
是继承了Annotation的特殊接口，具体实现是java运行时生成的动态代理类。
注解的scope属性定义了注解的作用范围
一般有类，方法，字段，还有构造函数和局部变量等
## future和completableFuture
两种异步编程方式，来自java.util.concurrent，可以访问异步计算的结果
c-future是future的增强
future主要有如下api：
- get(long timeout, TimeUnit unit),阻塞并等待结果
- cancel（boolean mayInterruptIfRunning），尝试取消任务
- isDone
- isCancelled
c-future除了支持complete手动设置计算结果， 还支持了thenApply等链式处理，并支持多个异步任务。
可以和ExecutorService一起使用，也可以自带执行器

# 设计模式
## 用volatile和synchronized实现单例模式
volatile保证多线程同步可见
synchronized+双重判断null，保证不会多个线程多次实例化
```java
public Class SingleTon{
	private static volatile SingleTon instance = null; // 类中定一个一个只能单线程访问的静态对象位置
	// volatile 保证了所有线程都能立即看到修改后的值，并不准指令重排， 但不能保证原子性
	private SingleTon(){} // 构造方法私有，用静态方法块初始化
	
	public static SingleTon getInstance(){
		if(instance == null){
			synchronized(SingleTon.class){ //只有一个线程能访问这个类
				if(instance == null){// 已经有多个线程在排队这个锁了，如果不判断，锁结束后，还是会有多个线程开始创建
					instance = new SingleTon();
				}	
			}
		}
		return instance;
	}
}
```

## 代理和适配器
代理是添加额外功能， 适配器是为了让不兼容的接口工作。

# 值复制和引用复制

java 方法永远是值复制，如果给引用类型，会对引用进行复制（此时对象还是同一个）


# 随机
使用util.Random类
```java
Random  rand = new Random();

rand.nextInt(bound) # [0,bound) ,integer
rand.nextDouble() # [0, 1), double
rand.nextBoolean()
```

