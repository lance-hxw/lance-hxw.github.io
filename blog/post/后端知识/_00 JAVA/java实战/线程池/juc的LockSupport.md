这是实现A Q S的工具类，他提供了底层的线程阻塞和唤醒机制，用于：
- 精准控制线程阻塞和唤醒
- 相对Obj更加灵活
LockSupport和CAS组合，就可以实现锁，具体看[[AQS实现]]
## 主要方法
- park()： 让当前线程阻塞
- parkNanos(long nanos)， 让当前线程阻塞指定ns
- parkUntil(long deadline)，让线程阻塞到时间戳
- unpark(Thread thread)，唤醒指定线程对象
## upark一个特性：基于许可
这个许可可以存储一个，当一个线程调用park的时候，如果已经持有许可，直接不会阻塞。
这个类似二元信号量（Binary Semaphore），但是更轻量
park操作：
- 检查当前线程是否有permit
- 如果有，立即返回，不阻塞
- 否则线程waiting， 等待唤醒
unpark操作：
- 如果已经阻塞，立即唤醒
- 如果没有调用park，提前存储permit
注意：
permit最多一个，park消耗一个
## locksupport底层 基于系统的线程阻塞操作
