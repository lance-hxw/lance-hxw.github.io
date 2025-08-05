表示容纳任意类型的值
如
var a  interface{}
此时a可以存储和传递任意类型
但是取出来时不知道是什么类型

# 类型断言 .(type)
取出来是没有类型的， 用不了， 所以必须用类型断言指定类型
```go
value :=e.Value.(int)
```
如果断言错了， 会panic

这个方法提供带判断的版本：
```go
value, ok := e.Value.(int)

if ok {
	// 断言正确
} else {
	// 错误
}
```
例如在container/list中，所有元素取出来都必须用类型推断