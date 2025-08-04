在为类型添加方法的时候， receiver可以是value receiver
或者pointer receiver
区别是：

# 对调用者本身影响

- value：方法内部操作receiver的一个副本
- pointer：操作原对象
# 大小和性能
- 大结构体， 用value会复制，比较耗时
- 小结构体，可以根据语义选择
# 方法集合与接口实现
method set定义决定了一个类型是否实现了某个接口

对于一个类型T

值类型T的方法集合包含所有value receiver声明的方法

\*T的方法集合包含了value 和pointer receiver的方法


所以在尝试实现一个接口时，如果某些方法用的pointer receiver实现，就只能用\*T来作为可用对象

即这样是会报错的：
```go
type A interface {
	met(name string) string
}

type Person struct{}

func (p *Person) met(name string) string{
	...
}

var a A
a = Person{}
// Person类型根本没有实现A接口
// *Person实现了A
可以这样
a = &Person{}

```
使用&Person{}的时候
是先用一个复合字面量（不过都是0值初始化）创建一个Person对象， 然后取地址