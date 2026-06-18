用于处理协程并发和控制，可以控制g的生命周期，使用更少的计算资源同步信号

也可以在网络编程中传递上下文信息

context是并发安全的， 一个context可以传给多个goroutine

# 结构

context实现context.Context接口， 定义了四个幂等方法：
- Deadline，返回完成工作的截止时间
- Done，返回一个channel，多次调用会返回同一个channel，如果g执行完或者上下文取消， channel会被关闭
- Err，在channel关闭时返回非空的值，被取消是canceled，超时是DeadlineExceeded
- Value， 从context预设键值对中取预设值，没有就返回nil

# 使用

## 起始上下文

使用context.background，是默认上下文

## 派生上下文

如果需要附带功能， 就要用派生上下文， 如：
- withCancel，可以用cancel取消协程

# 原理
