
# JDK动态代理：
```java
public class ProxyFactory {  
    public static <T> T getProxy(Class interfaceClass, String version){  
        // load config  
        // jdk proxy        
        Object proxyInstance = Proxy.newProxyInstance(interfaceClass.getClassLoader(), new Class[]{interfaceClass}, new InvocationHandler() {  
            @Override  
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {  
                Invocation invocation = new Invocation(interfaceClass.getName(), method.getName(), args, method.getParameterTypes(), version);  
                HttpClient client = new HttpClient();  
                String result = client.send("localhost", 8052, invocation);  
                return result;  
            }  
        });  
        return (T) proxyInstance;  
    }  
}
```
传入一个Class数组是因为可以实现多个接口

## InvocationHandler
参数是
- Object proxy
- Method method
- Obejct\[] args
可以用method获取方法名
获取方法参数类型的Class列表
args是具体参数的Object列表
# cglib（code generation library）

不需要接口
要引入第三方库CGLIB
实现步骤：使用Enhancer类和MethodInterceptor接口实现代理逻辑
```java
class MyService{
	public void say(String name){
		System.out.println("hello" + name);
	}
}

class MyMethodInterceptor implements MethodIterceptor {
	@Override
	public Object intercept(Object obj, Method method, Objects[] args, MethodProxy proxy) throws Throwable{
		xxxxxxxx
		Object result = proxy.invokeSuper(obj, args);// 原本实例类对象，和参数，
		xxxxxxxx
	}
}

// main
Enhancer enhancer = new Enhancer();
enhancer.setSuperClass(MyService.class);
enhancer.setCallback(new MyMethodInterceptor());// 用回调设置上去

MyService proxy = (MyService) enhancer.create();

proxy.say("bro");

```