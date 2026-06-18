java.lang.Thread
继承关系：
public class Thread extends Object implements Runnable
## 两种使用方式
### 直接继承Thread类，重写run方法
### 直接实现Runnable接口，就可以用这个类来初始化一个Thread
即：
ClassA implements Runnable
Thread thread = new Thread(new ClassA());
这里的特例就是，因为Runnable是一个函数式接口， 所以可以直接用一个方法引用或者一个lambda去作为实现。
## 重要方法
### start， 运行run方法， 注意不能直接调用run，不然就是在主线程调用了
### run，用于重写逻辑
### join(), 让当前线程等待调用这个thread， 如：
```java
Thread thread = new MyThread();
thread.start();
thread.join(); // 当前线程阻塞， 等待thread完成
```
### sleep， 休眠若干毫秒
### interrupt，中断线程，通知该线程应该停止， 即：
```java
thread.start();
thread.interrupt();// 通知这个线程停止
```
### setDaemon(true), 设置守护线程，当所有非守护线程结束后，守护线程自动终止
```java
thread.setDaemon(true);
thread.start();
```

## Thread 的状态
共有6个状态：
- NEW： 刚创建，但没调用start
- RUNNABLE：正在运行，或者准备运行
- BLOCKED：等待锁而阻塞
	- 如lock.lock
	- 如synchronized(obj)
- WAITING：等待其他线程的通知，如Object.wait和join
- TIMED_WAITING: 等待一段时间，如sleep和join（time）
- TERMINATED：结束运行
## Thread的优先级：
可以设置优先级，使用setPriority， 默认5， 可以设置Thread.MAX_PRIORITY

## Thread.yield: 让线程变成就绪而不是运行，重新竞争cpu调度权
作用是防止长时间占用