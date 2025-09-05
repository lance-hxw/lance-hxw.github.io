# TypeReference
是Jackson的一个类，用于反序列化的时候应对泛型的类型擦除，告知反序列化器实际的类型
如：
```java
List<String> fruitList = objectMapper.readValue(json, new TypeReference<List<String>>(){});
```

# Class T， Class ？， Object

Object是所有类的上界

Class\<T> , 是类型令牌， 用于表示某个具体类的运行时类型信息， 用于传递类型信息
- 是一个Class对象
- 可以反射生成T类型对象

Class\<?>, 通配符类型版本的Class对象， 表示未知类型的Class对象（某个类的Class对象！！不是单独的）
- 这是一个Class对象， 但不知道原类型
- 只能用于newInstance 一个Object类型