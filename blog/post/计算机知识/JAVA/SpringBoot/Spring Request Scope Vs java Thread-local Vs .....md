- 相同点: 二者都可以用于对一个请求中的局部变量管理
- 不同点:
	- thread-local有内存泄露风险, 线程可能被复用
		- 此时需要在请求结束后调用threadlocal.remove(), 或者使用请求/响应拦截器的afterCompletion()之类的操作
	- 性能: Threadlocal还有缓存机制 , 会更快, 而且spring的注入需要用反射, 而这涉及动态类型解析, 这个过程会非常慢
## thread-local 和 使用方式
线程局部变量表, 在java中, 每个线程都有一个ThreadLocal下的threadLocalMap类型, 使用完需要remove
```java
public class xxxxService {
	private ThreadLocal<xxxx> xxxholder = new ThreadLocal<>();
	public void xxxxxx(){
		holder = xxxholder.geet();
		holder.set("dgsdf");
	}
	public void xxxx(){
		holder = xxxholder.get();
		..
		holder.remove()
	}
}
```
## ScopedValue
JDK20中开始的玩意, 不是为了取代threadlocal, 是为了让结构化并发中的虚拟线程有各自享有外部变量, 为了解决threadlocal中的问题:
- threadlocal变量可变, 容易被多处修改, 不可维护
- threadlocal生命周期很长, 不用remove, 会内存泄露.
## Ref.
[Spring Request scope vs java thread-local - Stack Overflow](https://stackoverflow.com/questions/25406157/spring-request-scope-vs-java-thread-local)
[ThreadLocal vs ScopedValue. Managing Thread State: Comparing… | by Alex Klimenko | Medium](https://medium.com/@alxkm/threadlocal-vs-scopedvalue-a348c37658d8)
