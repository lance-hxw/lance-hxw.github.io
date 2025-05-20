每个Lock都与一个A Q S实例关联，每个Lock都可以创建多个condition对象
为什么要用condition，而不直接用lock
## 惊群效应
当signalAll的时候，不要把所有想拿锁的都唤醒
比如生产者消费者要用一把锁，但是要设置两个条件进行逻辑分组。
## condition
一个lock可以创建多个condition对象，每个condition都维护了一个单独的等待队列，即ConditionObject
当线程调用await，就进入Condition维护的条件等待队列
- 注意不是直接进AQS的同步队列
当signal调用的时候，将线程放到AQS中，等待获取锁
## condition与lock的AQS交互
- 线程调用lock.lock()， 获取锁，aqs记录当前持有锁的线程
- 线程调用await
	- 当前线程释放锁，进入condition的等待队列，线程进入waiting状态
	- 在AQS中释放锁
- 线程调用signal
	- signal将condition中的首个线程移动到aqs中，并使其进入runnable状态
	- 但他只是去aqs中进行竞争。如果没竞争到，就会变成waiting状态进入同步队列
	- 注意aqs哨兵后面那个会边runnable
### conditoin与AQS的绑定：
reenLock调用newCondition的时候，创建一个ConditionObject， 将其关联到ReenLock
ConditionObject中维护一个等待队列，存放waiting线程
signal将线程从条件队列移动到同步队列
## lock和aqs的关系
每个lock都有一个aqs子类的实例，reenLock使用Sync，继承自AQS
Sync特点是：
- 独占锁
- 两个子类：公平锁和非公平锁
	- FairSync和NonfairSync，重写了tryAcquire和tryRelease
## 其他：
condition有个awaitUninterruptibly方法，不会被中断