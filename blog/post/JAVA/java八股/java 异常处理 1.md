## 完整的java try-catch
```java
public class TryCatchExample {
    public static void main(String[] args) {
        try {
            // 可能抛出异常的代码
            int result = 10 / 0; // 故意制造一个异常（ArithmeticException）
            System.out.println("结果是：" + result);
        } catch (ArithmeticException e) {
            // 处理算术异常
            System.out.println("捕获到算术异常：" + e.getMessage());
        } catch (Exception e) {
            // 捕获所有其他类型的异常
            System.out.println("捕获到一般异常：" + e.getMessage());
        } finally {
            // 无论是否发生异常都会执行的代码
            System.out.println("执行清理操作，无论是否有异常都会运行。");
        }
    }
}

```
## 方法后的throws

这个语法是为了提醒这个方法的使用者, 这个类可能抛出一个异常, 必须要处理
注意, 这个是**强制**的, 如果你在使用这个方法时没写异常处理, 编译会不通过.
这个语法是为了强制开发者进行异常处理, 一般在io服务类方法上可以写这个

并且, 子类中方法抛出的异常, 也是接口/父类中声明的异常的子类