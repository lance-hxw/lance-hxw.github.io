

任何阻塞的方法都会抛出这个异常
无论是子线程中的，还是主线程中的awaitTermination

处理线程中断，在中断情况下被抛出。
即当线程处于：
- waiting
- timed_waiting
- blocked
这些状态中，其他线程对他调用interrupt通知其中断，就会出现这个异常
此时直接抛出一个异常，让程序决定如何处理，而不是立即结束

## 常见交互方法
Thread.sleep
Thread.join

Object.wait
LockSupport.park
Condition.await

BlockingQueue.take
Selector.select // NIO,而且是select
