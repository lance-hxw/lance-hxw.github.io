流式接口的一种实现
我们可以这样实现:
```java
public class Chain<T> {
	privae T value;

	public Chain(T value){
		this.value = value;
	}
	// of 是方法名, 第一个<T> 是方法级泛型声明
	// 静态工厂
	public static <T> Chain<T> of(T value) {
		return new Chain<>(value);
	}

	public <R> Chain<R> thenApply(Function<T,R> mapper) {
		R newValue = mapper.apply(this.value);
		return new Chain<>(newValue);
	}

	public Chain<T> thenAccept(Consummer<T> action){
		action.accept(this.value);
		return this;
	}
}
```
其中使用了Function和Consumer两个[[java 函数式接口]]
