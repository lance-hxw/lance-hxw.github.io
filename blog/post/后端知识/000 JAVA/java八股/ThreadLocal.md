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
	- 所以必须设置为static
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

# 实战

创建一个静态的ThreadLocal\<T> local

后续使用时， 每个线程都去调用这个变量，但是拿到的结果是独立的

其逻辑是， 每个线程中都有一个独立的ThreadLocalMap

但是， 其key是一个ThreadLocal对象

所以当我们调用local去set值的时候， 实际是用local作为本地Map的key的一部分了

为了在这里set进去后方便再拿出来，这个“key”就必须是static的，这样也方便清理，并且防止泄露。

如果需要存多个kv对：
- 可以定义多个static的ThreadLocal对象
- 也可以定义一个值为Map的ThreadLocal对象

实际使用时， 将ThreadLocal设置成static， 加上remove， 一般不会出问题。