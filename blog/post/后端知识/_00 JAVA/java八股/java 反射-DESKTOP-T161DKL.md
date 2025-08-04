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