用于在线程中创建专属于这个线程的变量池
## 实现
每个Thread对象都有一个ThreadLocalMap，里面存储线程相关的变量
每个ThreadLocalMap里面的key是ThrealLocal\<T>对象，这是一个弱应用的对象
### ！！！
ThreadLocalMap中存的是Entry对象，Entry持有一个key（ThreadLocal）的弱引用
持有一个value的强引用，就算清理了ThreadLocal（通过弱引用+GC），Entry对象还是存在，此时value就一直持有一个强引用，导致内存泄露。
## 注意
- TheadLocal对象本身会被清理
	- ThreadLocalMap持有的是ThreadLocal的弱引用，只要服务不持有强引用，他就会被GC
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
```java
TreadLocal<Integer> curId = new ThreadLocal<>();
curId.set(1);
curId.remove();
```
# 引用相关
key设置弱引用是为了防止内存泄露（如果没gc就算弱引用还是会泄露）
value不能设弱引用， 不然一放进去值直接就没了。