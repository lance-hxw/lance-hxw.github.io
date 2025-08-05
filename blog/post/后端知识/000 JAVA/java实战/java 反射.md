Class.forName(String className)
获取Class对象
实际调用了
```java
forName(String name, boolean initialize, ClassLoader loader)
```
第二个参数默认传入true，即类会被初始化
初始化后，静态变量就会实例化，静态代码块被执行
即使用Class forName加载的类会被初始化和执行

获取构造函数时，要传入class对象指定构造函数，如果构造函数中有基础数据类型，需要用int.class, 或者Integer.TYPE，不能用Integer.class