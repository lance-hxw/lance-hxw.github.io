出现的地方:
 - SpEL

## 基本用法
```java
import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class ReflectionExample {
    public static void main(String[] args) {
        try {
            // 1. 加载类
            Class<?> clazz = Class.forName("Person");
            
            // 2. 创建类的实例
            Object person = clazz.getDeclaredConstructor().newInstance();
            
            // 3. 获取字段并设置值
            Field nameField = clazz.getDeclaredField("name");
            nameField.setAccessible(true); // 绕过权限检查
            nameField.set(person, "Alice");
            
            // 4. 获取方法并调用
            Method greetMethod = clazz.getDeclaredMethod("greet");
            greetMethod.setAccessible(true); // 确保可以调用私有方法
            greetMethod.invoke(person); // 调用方法
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

// 辅助类
class Person {
    private String name;
    
    private void greet() {
        System.out.println("Hello, my name is " + name);
    }
}

```

## 什么地方用到了反射机制
- Spring IoC的依赖注入，会利用反射来实例化对象
- Mybatis的结果映射， 通过反射来创建pojo对象，并填充
- SpringMVC的请求分发，dispatcher动态调用目标方法
	- 执行过程：
		- 接受请求后， 解析url去匹配RequestMapping
			- 这个过程是用反射找这个字段
		- 找到具体方法后，动态调用接口方法，并根据接口各种注解，将请求的数据解析成方法需要的输入，然后调用。
		- 将结果返回
- AOP，运行时将增强代码写入目标对象的方法中，过程中使用了反射机制
	- 直接创建一个代理对象，
		- 对接口代理，使用jdk动态代理
		- 对类代理，使用CGLIB生成子类
	- 代理对象通过反射调用实际的业务方法
