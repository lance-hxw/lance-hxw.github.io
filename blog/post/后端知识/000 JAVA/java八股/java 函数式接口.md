自java8可用, 用于支持函数式编程
函数式接口特点:
 - 一个函数式接口只包含一个未实现的抽象方法, 可以用于lambda
	 - 可以用一个函数式对象接受一个lambda
	 - 可以在接受一个函数式对象的地方输入一个lambda
 - @FunctionalInterface接口, 仅用于编译检查, 非强制
 - 可以包含多个默认方法(default修饰)或静态方法
任何一个只有一个抽象方法的接口(即函数式接口), 都可以用一个具有匹配方法签名的方法引用赋值.
- 如你Consumer\<T>中有个accept(String ), 那就可以用Sytem.out::println来赋值
- 比如Supplier的get() 没有参数, 所有返回值对应的方法都能匹配上
## 内置函数式接口
- Supplier\<T>:  无输入, 只返回一个值
- Consumer\<T>: 接受一个参数, 无返回值(但可以有别的操作)
	- 适用于forEach
- Function\<T,R>: 接受一个返回一个
	- 函数类的适用于诸如map和collect等
- Predicate\<T>: 接受一个参数, 返回一个boolean
	- 适用于filter
- BiFunction<T,U,R>: 接受两个参数, 返回一个结果
- UnaryOperator\<T>返回一个和输入类型相同的结果
- BinaryOperator \<T>: 接受两个T, 返回一个T

## 与Stream结合
函数式接口最常用的场景就是StreamAPI中, 如map, filter, forEach, 
如:
```java
a.stream().filter(PredicateObj).forEach(ConsumerObj)
```
类似的还有HttpClient的thenApply和thenAccept
- stream中的collect可以接受一个collector函数式接口实例类
	- 一般可以直接适用Collectors.toList()这类已经定义好的类
	- Collectors.toList()是一个collector类静态工厂
		- 一般list是一个arraylist, 但是这属于未定义
## 函数式接口的异常处理：
注意，由于接口已经定义，所以不能随意抛出异常，如果需要处理异常， 应该在函数的实现中处理，或者继承一个自定义接口用于抛出异常。