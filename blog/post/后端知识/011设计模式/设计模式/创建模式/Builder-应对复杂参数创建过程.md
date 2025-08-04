Builder用多个小工厂创建完整对象
一般整个对象需要多个对象组合
一般可以带个toObj或者build方法, 用于最后生成对象
```java
public class HXWBuilder{
	private HBuilder hBuilder=new HBuilder();
	private XBuilder xBuilder=new XBuilder();
	private WBuilder wBuilder=new WBuilder();
	public HXW toHXW(args){
		HXW hxw=new HXW();
		// args->HXW.data
		return hxw;
	}
}
```
比如常见的链式调用
```java
public class HXWBuilder{
	...
	public HXWBuilder appendToHXW(args){
		//args->this.HXW.data
		return this;
	}
	public HXWBuilder setToHXW(args){
		return this;
	}
	public HXW toHXW(args){
		return this.HXW;
	}
}

```