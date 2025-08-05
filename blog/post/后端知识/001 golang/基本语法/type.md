type用于定义或者创建新的类型
go中只有几个基本类型：
- int， float64， complex12
- bool
- string
- byte， rune（int32，表示unicode32码点）
以及复合类型：
- 数组： var arrName \[5]int{1,2,2,3,4}
- 切片（动态数组
	- var slice \[]int = \[]int{1,2,3}
- map
	- var m map\[string]int
		- = map\[string]int{"one":1}
- 通道 chan
	- var ch chan int = make（chan int）
- 指针 var ptr \*int
# 使用type定义新类型

## struct
这是最常见的，定义结构体
他的意思是，定义了一个新类型，其底层是struct
- 这不是继承关系，新结构体相当于一个空结构体变化而来，并没有继承关系
如：
```go
type Person struct {
	Name string 
	Age int
}

p := Person{
	Name: "abc",
	Age: 30,
	}
```

## interface
```go
type Reader interface{
	Method(p []byte) (n int, err error)
}
```
接口可以进行组合

```go
type ReadWriter interface{
	Reader
	Writer
}
```
## 类型别名
```go
type MyInt int// 新类型
type AliasInt = int// 同类型的不同名字

不同类型， 就算值一样， 类型不同也不想等
```

## 函数类型
定义有特定类型的函数类型
```go
type HandlerFunc func(name string) error
```

## 类型组合
即将其他类型作为成员组装进去，不需要名字
初始化的时候用类型名作为key
而且在逻辑中，这个被嵌入的类型会直接展开，不需要名字，直接用当前类获取即可

会继承方法和成员

###  同名冲突了怎么办

此时直接不能访问,需要指定具体struct名称
即 c.A.X和c.B.X
也可以在c里面重定义一个X, 避免冲突

如果是方法冲突了, 可以定义匿名接口字段
即这个接口只包含冲突的方法, 
然后在c对象初始化的时候, 将A或者B中的一个传给这个接口,然后就会调用指定A或B的该方法, 而且是展开的


# 类型断言和类型转换:指定类型

```go
var i interface{} = "hello"
s, ok := i.(string)
```

# 实际在干什么

type一个struct, 相当于定义了一个底层就是后面struct{xxx}的新类型, 可以用这个类型创建新对象或者值


type一个interface的时候, 实际相当于定义了一个interface{xxxx}的方法集合
任何实现了这个方法的类型都可以被认为是这个接口的实现
可以说, interface{xx}就是一个方法集的约定

