
java的泛型是在编译期间用于类型安全检查，但是在运行时就会将泛型信息擦除，替换成原生类型或者边界类型（如泛型上界），这种涉及主要是兼容老版本的java

如List\<String>会变成List， 而String替换成Object，这样List就能装任何对象（当然，要动态写进去）

# 如何动态往list中写入任意类型
## 使用原始类型强制类型转换
直接把带泛型的list强转成原生类型，然后随便加

```java
List<String> stringlist = new ArrayList<>();
stringList.add("hee");

((List) stringList).add(123);
((List) stringList).add(new Object());
```
## 使用反射
直接用反射获取list对象的add方法
```java
List<String>  stringList = new ArrayList<>();
stringList.add("hee");

try{
	// 获取添加Object的add方法
	Method addMethod = List.class.getMethod("add", Obejct.class);
	addMethod.invoke(stringList, 123);
}
```