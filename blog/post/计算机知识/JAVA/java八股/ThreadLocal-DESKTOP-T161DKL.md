用于在线程中创建专属于这个线程的变量池
## 实现
每个Thread对象都有一个ThreadLocalMap，里面存储线程相关的变量
每个ThreadLocalMap里面的key是ThrealLocal对象，这是一个弱应用的对象
## 注意
- ThreadLocal对象本身会被清理
	- GC时
	- 线程关闭时整个map都清理
但是value是强引用，引用heap中具体的对象
如果ThreadLocal没有被GC回收（线程池）：
- 那么其value就有一个强引用，导致对象不能被回收

即：
- ThreadLocal应该用remove清理value
- 不要用setnull清理，
- 应该设置在finally中remove，一定要清理

此外，ThreadLocal不清理还会导致如果没发生GC，值泄露到线程的下一次使用

## 使用