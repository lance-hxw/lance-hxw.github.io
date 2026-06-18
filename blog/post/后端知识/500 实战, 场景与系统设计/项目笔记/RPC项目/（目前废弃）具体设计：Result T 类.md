
# 成员变量
- value
- errMsg
- status
对应g/s需要实现

# .success方法：
相当于工厂
即：
```java
public static <T> Result<T> success(T data) {
    Result<T> result = new Result<>();
    result.success = true;
    result.data = data;
    return result;
}
```
