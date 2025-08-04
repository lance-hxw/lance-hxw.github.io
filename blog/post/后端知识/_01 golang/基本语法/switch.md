一种重型分支结构, 语法为:
```go
switch exp{
case v1:
	//
case v2:
	//
case v3:
	//
default:
	//
}
```
- 自动终止, 只匹配一个case, 不需要手动break
- 多值匹配, 一个case中可以用逗号分割多个值
- 默认分支: 只处理没有匹配上的情况
## 特殊情况
### 无exp swtich(只用于替代if-else链)
```go
score := 85
switch {
case score >= 90;
	//
case score >= 80:
	//
default:
	//
}
```
这个操作中, 每个case都是布尔表达式, 为true就匹配上

### 类型匹配(type switch): "是专用语法糖, 不应该被推广到别的上下文"
```go
var data interface{} = "hello"
switch v:=data.(type) {
case nil:
case int:
case string:
default:
}
```
注意这种要处理nil
这个v:=data.(type) 是一种特殊语法只能在switch中写, 能获取data底层实际类型赋值给v
这是一种广泛的"类型断言" 正常的类型断言只能转换+判断是否ok
### 穿透执行 fallthrough
```go
n := 2
switch n{
case 2:
	fallthrough
case 3:
	xxx
}
```
这种情况下, 会强制执行下一个操作, 无论case有没有匹配上

所以case执行有两种情况: case匹配上, 或者被上面穿透了
