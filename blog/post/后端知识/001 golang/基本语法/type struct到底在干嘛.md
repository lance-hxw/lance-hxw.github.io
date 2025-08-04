type a struct
type b a

这个过程中， a的底层被声明成一个struct{...}
如：
```go
type a struct{
	x string,
	y int,
}
```
那么a的底层就是一个 stuct{x string; y int}
然后b的底层就是a，所以b也是struct{x string; y int}

# 字段

由于底层相同， 所以字段也相同，可以一样访问

# 方法

方法是不共享的， b不会继承注册给a的方法

如何”继承“？

可以重写一遍， 或者：
embedding进去
即
```go
type b struct {
	a
	...
}
b.foo() //等于a.foo()
```
embedding的字段会自动展开
方法会promoted， 即提升到b这个层级
