java.util.concurrent, 是java并发编程的核心，主要提供了
- 锁： 比synchronized更灵活的锁，如ReentrantLock，ReadWriteLock
- 原子变量：AtomicInteger等， 基于硬件的无锁原子化
- 线程池， ExecutorService和实现（线程池
- 并发集合，如ConcurrentHashMap，COWArrayList
- 同步工具类，CountDownLatch，CyclicBarrier，Semaphore
- 阻塞队列，ArrayBlockingQueue（线程安全队列）等
- Future模式，Future，FutureTask等

可以认为， volatile和CAS是Atomic类的基础，Atomic类是AQS的基础
A Q S是juc的基础
## Lock接口
juc.locks.Lock提供了更强大的锁定机制，ReentrantLock是一个实现，用法如下：
```java
private final ReentrantLock lock = new ReentrantLock();

public void someMethod(){
	lock.lock();
	try{
	}finally{
		lock.unlock();
	}
}
```
是非监视器锁，他是为一个实例实现一个lock对象，然后对这个对象自己上锁，用于标记，更加灵活

另一个实现是ReadWriteLock，读写锁，允许多个读，一个写。
- sync。和ree。都是互斥独占锁
- 分成读和写两个锁，区别是允许的个数，读锁是为了数据一致。

### sync. 和 reenta的区别
- 都可重入
- sync不可中断， reen.可以中断
	- 使用lockInterruptibly（），可以正常获取锁
		- 如果进入了等待状态，此时需要取消任务等，可以被中断
		- 别的地方调用这个线程的interrupt（）方法，就会响应
			- 停止等待
- 公平， reen创建时可以指定公平锁
- reen粒度更小

## CountDownLatch
先创建一个指定个数的计数器（只能用一次）
然后在thread执行代码中结束时执行countDown（）
然后在主线程中写latch.await(),等待计数器归零
- 适用于类似map-reduce的归一处理操作
## cyclicBarrier
允许一组线程相互等待，直到公共屏障点，然后全部去执行后续操作，这个屏障可以复用。
- 侧重于线程相互等待的一致性，而不是最终统一处理。
使用方法是，定义一个指定个数的barrier， 然后在线程方法中使用barrier.await()在线程中一个点统一等待。
- 就是按照线程个数循环，每n个线程一组，每次await被调用时计算一次。
- 当await计数达到设定值，所有线程都唤醒，然后计数器重置。
并且支持在await结束时执行统一操作
## waiting和blocked区别
 等待：
 - 调用特定方法进入等待状态，此时会释放持有的锁，进入等待
	 - Obejct.wait直接让一个对象等待，当前线程就进入这个对象的等待池，直到其他线程调用这个对象的notify或者notifyall，唤醒
	 - Thread.join
	 - LockSupport.park():当前线程等待，需要unpark唤醒
 - 然后等待被别的线程唤醒
阻塞
- 获取锁的时候， 可能进入阻塞

主要区别是，阻塞是等待排它锁，等待是等对象/事件
阻塞是被动的， 等待是主动的
可以用等待实现锁


# 原子变量
AtomicInteger， AtomicBoolean等
其内部value是volatile的
可以用来实现CAS，保证原子性
即使用AtomicObj.compareAndSet(expexedValue, newValue);
如果写成功了就返回true；否则false
然后外面套一个while就实现了自旋CAS
- 这里注意， 如果一直while， 就非常消耗cpu资源
- 此时可以把线程直接waiting
这个就可以当一个上锁操作，解锁也是一样
不过解锁的时候要注意自己有没有锁
- 这个只要在mylock对象中定义一个Thread对象owner判断是不是当前线程就行了。
Atomic的CAS都要old value才能设置
# Atomic Reference
普通的引用是引用数据类型，如果一个引用数据也需要保证并发安全， 就需要使用Atomic Ref， 如多线程中的链表头尾
需要用get来获取对象,  set来进行设置
用compareAndSet原子更新

# AQS
AbstractQueuedSynchronizer
一个锁，同步器和写作工具的框架
AQS用一个Volatile的变量表示同步状态，用FIFO队列实现公平锁
使用CAS操作完成锁状态修改
- 这个实现可以用Atomic对象实现，提供了CAS操作和volatile性质
Sync就是AQS的实现， 也是ReentrantLock等类的的基础

## 简单实现AQS锁
- 拿不到锁的时候把当前线程放进队列
- 解锁的时候唤醒队列中下一个线程。

```java
public class AQS{
	// lock state, cas & volatile, 
	AtomicBoolean state = new AtomicBoolean();
	
	Thread owner = null; // lock owner
	
	AtomicReference<Node> head = new AtomicReference<>(new Node());

	AtomicReference<Node> tail = new AtomicReference<>(head.get());

	void boolean lock(){
		if (state.compareAndSet(false, true)){
			owner = Thread.currentThread();
			return ; // return == make currentThread active
		}
		// can't get lock
		Node curNode = new Node();
		curNode.thread = Thread.currentThread();
		while (true){
		// 一直找新的尾巴尝试插入
			Node curTail = tail.get();
			if(tail.compareAndSet(curTail, curNode)){
				curNode.pre = curTail;
				curTail.next = curNode;
				break;
			}
		}
		// 将自己放入队列，开始等待唤醒，唤醒后从park下面开始执行
		// 注意这里，可能出现虚假唤醒或者其他异常
		// 如果是虚假唤醒，没轮到自己就继续等待
		// 如果唤醒了发现抢不到锁，有异常，就继续等
		// 注意在判断完没拿到锁，到插入，这个过程中锁可能释放了
		// -- 此时需要在阻塞前再看看有没有锁
		// -- 为了避免undo append， 用唤醒自己这个逻辑实现
		while (true){
			if (curNode.pre = head.get() 
			&& state.compareAndSet(false, true)
			){// 正常情况值唤醒一个，应该肯定能拿
				owner = Thread.currentThread();
				// 上面这些操作都是因为没有锁
				// 现在有锁了做什么都是原子的
				head.set(curNode);
				curNode.pre.next = null;
				curNode.pre = null;
				return; // get
			}
			// 先判断一次有没有在过程中错过上一个节点的唤醒
			LockSupport.park();
		}

		
	}
	void boolean unlock(){
		if(Thread.currentThread() != this.owner){
			throw new IllegalStateException("no lock");
		}
		// 后面是持有锁的逻辑
		Node headNode = head.get();
		Node nextHead = head.next;
		state.set(false);
		if (next != null){
			LockSupport.unpark(next.thread);
		}
	}

	class Node{
		Node pre;
		Node next;
		Thread thread;
	}

}
```


# volatile
保证了多线程环境下，一个变量操作的可见性
由于cpu缓存的性质，一个变量的变动难以同步到不同线程中去
同时java中也规定每个线程有工作内存，不过变量都应该存在主内存中

## 实现机制
- 内存屏障
	- 一个volatile变量写操作，编译器会在写后面加一个Store Barrior
		- 强制将最新值刷到主内存中
	- 在读时， 在读之前插入一个Load barrior
		- 让当前线程中的副本失效，去主内存读
- ban指令重排
	- 保证有序， 即保证了写读操作与内存屏障关系不错位
		- 这样就能保证可见性

从字节码上看，只是内存屏障的区别
在汇编层面，可能会用lock总线去写volatile对象，保证原子性（但不一定，而且这代价太大了

# LockSupport
相比Object wait和notify， 更加灵活方便强大
object的这写方法需要在同步方法/代码块中运行，并且必须要先拿到锁，是锁拥有者去操作。
object也不能指定某个线程唤醒，是不公平的
**注意**， 就算unpark在park前调用，也是可以的
- locksupport是基于许可机制而不是唤醒
	- 每次获取锁就消耗许可
	- 许可不能累计，最多一个
- 但是如果锁拥有者根本没发现有其他请求者， 就没办法了
object一般是和sync.一起用，必须获取锁后用
## park
- park()， 阻塞当前线程
- park(object blocker)， 设置一个阻塞对象， 用于调试
- parkNanos(long nanos), 阻塞最多纳秒，如果时间内被唤醒或者中断，也会唤醒
## unpark
- unpark(Thread)， 许可一个线程

## parkUntil(long deadline)
阻塞到绝对时间
过程中被许可或者中断， 会唤醒