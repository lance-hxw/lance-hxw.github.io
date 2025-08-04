Singleton
```java
public class Singleton{
	private Singleton(){}// 防止实例化
	public static final Singleton INSTANCE=new Singleton();
}
```
- pirvate构造方法, 让外部无法实例化
- 通过static变量持有唯一实例
- 通过public实例或者public一个get方法, 暴露此实例


注意:
- 在单线程中, 可以延迟加载: 第一次调用时才实例化
	- 但是多线程中, 如果这样写还得加锁, 不如直接实例化
	- 双重检查: 检查是否已经实例化, 但是java中不存在
- 另一个实现方式是单一枚举, enum总是单例
	- 这让通过序列化和反序列绕过private构造的问题没有了.
- 实现:
	- 一般都是约定让框架实例化这些类, 使用时调用获取
	- 如@Component
	- 一般不刻意实现