用于在函数前后执行逻辑,相当于finally的意思
可以有多个, 顺序是FILO, 即按写顺序进stack
- 写在循环中的也是一样
```go

func func1(){
	defer fmt.Println("func1")
}
func func2(){
	defer fmt.Println("func2")
}
func main(){
	defer func1()
	defer func2()
}
// 结果是func2, func1
```
# 与return的关系
先执行return  然后执行defer
其含义是整个函数结束后调用, return是函数生命周期中的
