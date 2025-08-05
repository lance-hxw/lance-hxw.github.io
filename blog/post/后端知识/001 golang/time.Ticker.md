ticker.c是一个只读通道, 类型是<-chan time.Time
每次tick都会发送当前时间到通道, 没有接收者也不会阻塞
# 必须停止
```go
ticker := time.NewTicker(time.Second)
defer ticker.Stop()
```

# 使用

```go
ticker := time.NewTicker(1 * time.Second)
defer ticker.Stop()

for {
	select {
	case t := <-ticker.C
		// do sth.
		...
	}
}
```
是用ticker.C来计时, 而不是在for里一直创建ticker

# 与for中用sleep的区别
用ticker可以用多个频率的, 更加灵活
ticker是一个g+内部定时器, 轻量, sleep每个g里都得卸
sleep是系统调用, 开销大
ticker+select便于终止, sleep只能睡

# time.Tick
最好不用, 这玩意创建就丢失引用, 无法关闭, 只能与程序同生命周期, 还难以放在for中用
只能for range tickname
// 唯一正确的用法：简单的 for range 
for range time.Tick(1 * time.Second) { 
	fmt.Println("定时任务") // 注意：这里也无法优雅停止 
}
