接口的转换, 一个wrapper就是**实现B接口, 持有A接口的类, 转换功能**
```java
public A2BWrapper implements B{
	private A a;
	public A2BWrapper(A a){
		this.a=a;
	}
	public void b(){
		a.a();
	}
}
```