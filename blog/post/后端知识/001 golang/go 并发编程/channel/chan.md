用于goroutine之间的通讯, 无需显式加锁
# 基本用法
## 声明和初始化

```go
var ch chan int // int chan
ch = make(chan int) // 初始化一个没有缓冲区的chan

或者

ch :=make(chan int)
```
## 发送和接收数据
```go
ch <- 10 // 将一个数据发送进chan
x := <-ch // 从chan接收一个数据并赋值给x
```
如果chan没有缓冲区, 读写都是阻塞操作, 直到另一段准备好, 这不是队列, 或者说是一个容量为0的阻塞队列
## 带缓冲区的通道
```go
ch := make(chan int, 3) // 一个容量是3的缓冲区通道
ch <- 1
ch <- 2
ch <- 3
ch <- 4// 这里会阻塞, 除非有对象在接收
```

## 关闭通道
close(ch)
一个通道被关闭后不能往里发数据, 但是可以继续取, 直到空
可以用 v, ok := <-ch 判断通道是否已经关闭

## 与for-range结合使用
```go
for v:=range ch{
	// 注意, 直到通道关闭, 这个for-loop才会退出, 否则一直阻塞
}
```


# 基本例子
```go
func worker(ch chan string){
	xxx
	ch <- "hello from worker"
}

func main(){
	ch := make(chan string)
	go worker(ch)
	msg := <-ch
}
```

# 单向通道

```go
func send(ch chan<- int){
	ch <- 10 // 只能发送
}

func recv(ch <-chan int){
	x := <-ch // 只能接收
}
```
# 多路复用
```go
select {
case msg := <-ch1:
	//
case msg2 := <-ch2:
	//
default:
	//
}
```

