一般会在controller处理请求的通用逻辑中写上defer recover(), 用于捕获panic防止整个服务宕机，优雅处理错误

# 何时导致宕机
使用net/http的服务器时，对每个请求的goroutine有一个内置恢复机制，可以捕获handler中的panic，记录错误， 响应500

但是自己写的cotroller中手动创建的goroutine不会被捕获

# 为什么宕机
panic是不可恢复错误， 意味着数据不一致，不宕机会导致更验证的问题

# recover
作为一个出口， 处理panic
一般写成这样：
```go
defer func(){
	err := recover()
	if err != nil {
		// panic log ... 
	}
}
```
