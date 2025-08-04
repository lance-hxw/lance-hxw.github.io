- 无序键值对
- kv存储
- 集合,可以迭代, 但是无序
- 空值为零值
- 引用类型,赋值的时候会传递对象
必须要先make, 或者字面值, 不然是没有内存的会报错
# 定义
标准方法是用make
```go
mapVar := make(map[string]int, 0) 初始0

或者 用字面值 
map[string]string{}
```

# 使用

```go
myMap := make(map[string]string)
// add
myMap["china"] = "bj"
// del
delete(myMap, "china")

// iter
for k, v := range myMap{
	...
	k..
	v..
	...
}

// upd
myMap["china"] = "nj"

// 传递, 注意是引用传递
func func1(mp map[string]string) {
 ...
}
```
# default?

# 注意:
## 拷贝?
map不能拷贝, 只能for range 循环复制

## 修改map的嵌套value
如果value是结构体, 只能直接修改结构体对象, 不能修改结构体内部的值

因为map是线程不安全的, 就设计成不能修改的了


如果要修改, 就得用指针或者拷贝
