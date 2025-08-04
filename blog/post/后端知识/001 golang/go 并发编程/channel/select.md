用于操作多个chan的关键工具， 可以同时等待多个chan操作完成(发送或者接收)
并在其中一个操作准备就绪时, 执行对应代码块
## 具体语法
```go
select {
case x := <-ch:
	// ..
case ch2 <- x:
	//
case <-ch3:
	//
default:
	// 如果所有case都不能做(都在阻塞)了, 就执行default
	// 如果没有default, 就一直阻塞到能执行其中一个
}
```
注意:
 - 如果只有一个case能执行, 就执行
 - 如检查所有case, 发现有多个能立即执行, 随机执行一个, 避免饥饿(不能总是执行第一个case)
	 - 注意这里随即执行其实是对case随机排序后再执行第一个
 - 若全部阻塞, 就将主线程阻塞
	 - 如果有default, 会执行default, 不会阻塞
 - 执行完退出select, 只会执行其中一个分支
## 底层实现
是在go runtime 实现的, 不直接依赖于os底层就， 不过效率也非常高

goruntime使用一个scase结构体表示select中的每个case, 用一个sudog链表来管理等待队列
### 具体过程
1. 编译时转换, 将select转换成对runtime.selectgo函数的调用, 生成对应的case数组
2. 随机化和排序, 运行时对所有case随即排序避免饥饿, 然后按chan地址重拍避免死锁
	1. ?
3. 快速路径检查, 检查所有case, 如果找到就执行, 没有就阻塞
4. 阻塞:
	- 为当前goroutine创建一个sudog结构体
	- 将这个sudog同时加入所有chan的等待队列
	- 调用gopark将当前goroutine挂起
5. 唤醒
	- 如果一个chan可用, 立即在其等待队列中将goroutine唤醒
	- goroutine遍历所有case, 将自己从等待队列中删除
### 随机避免饥饿
在select每次执行时, 都会进行运行时随即排序, 避免某些case在顶上一直被执行
### 按chan重排避免死锁
这是因为select需要原子性检查所有case是否就绪, 需要持有所有chan的锁
#### 为什么需要锁
如果不锁, 可能刚检查完, 就有人往里塞东西, 然后就直接错过了

#### 如何上锁
将select中所有chan拿出来按地址排序(所有select对任意两个chan都有一样的加锁顺序, 不会死锁)
逐个上锁, 逐个检查, 获取所有chan的检查结果(并且由于上锁, 检查结果不会变动)
然后按照case(随机排序), 依次检查是否可以执行, 执行第一个, 然后释放所有锁, 清理所有队列中的自己.


# 常用实践
### 带超时等待
```go
select {
case data := <-ch:
	//
case <-time.After(time.Second * 2):
	//
}
```

