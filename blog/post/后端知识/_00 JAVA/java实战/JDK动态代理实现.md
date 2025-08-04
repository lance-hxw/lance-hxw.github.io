# InvocationHandler
一般用于动态代理
使用：
- 定义一个接口
- 创建目标对象
- 实现InvocationHandler接口，在invoke方法中自定义逻辑
- 使用Proxy newProxyInstance创建代理对象，让代理对象调用方法
```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public class MyInvocationHandler implements InvocationHandler {
    private Object target; // 被代理对象

    public MyInvocationHandler(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 在方法执行前添加逻辑（例如日志）
        System.out.println("调用方法：" + method.getName());

        // 执行目标对象的方法
        Object result = method.invoke(target, args);

        // 在方法执行后添加逻辑（例如后置处理）
        System.out.println("方法执行完成：" + method.getName());

        return result;
    }
}

```
然后在
```java
import java.lang.reflect.Proxy;

public class ProxyTest {
    public static void main(String[] args) {
        // 创建被代理对象
        HelloService target = new HelloServiceImpl();

        // 创建 InvocationHandler 实例
        InvocationHandler handler = new MyInvocationHandler(target);

        // 生成代理对象
        HelloService proxy = (HelloService) Proxy.newProxyInstance(
                target.getClass().getClassLoader(), // 类加载器
                target.getClass().getInterfaces(),  // 代理需要实现的接口
                handler                             // 代理逻辑
        );

        // 调用方法
        proxy.sayHello();
    }
}

```