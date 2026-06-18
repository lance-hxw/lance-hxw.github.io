# CountDownLatch 倒计时器
允许一个或者多个线程等待其他线程完成操作，主要两个api：
- await：使当前线程等待，直到计数器变成0
- countDown：计数器递减
countDown是一次性的
```java
import java.util.concurrent.CountDownLatch;

public class CountDownLatchExample {
    public static void main(String[] args) throws InterruptedException {
        int threadCount = 3;
        CountDownLatch latch = new CountDownLatch(threadCount);

        for (int i = 0; i < threadCount; i++) {
            new Thread(() -> {
                System.out.println(Thread.currentThread().getName() + " 执行任务...");
                latch.countDown();
            }).start();
        }

        latch.await(); // 等待所有线程完成
        System.out.println("所有线程执行完毕，主线程继续执行...");
    }
}

```
# CyclicBarrior
让一组线程等待，直到所有线程都到达终点，然后一起继续
自动刷新的
会抛出BrokenBarrierException，一般这重置就行
方法：
 - await：让线程等待，直到所有线程都到达终点
 - reset： 重置，用于复用
```java
import java.util.concurrent.CyclicBarrier;

public class CyclicBarrierExample {
    public static void main(String[] args) {
        int threadCount = 3;
        CyclicBarrier barrier = new CyclicBarrier(threadCount, () -> 
            System.out.println("所有线程到达屏障，继续执行...")
        );

        for (int i = 0; i < threadCount; i++) {
            new Thread(() -> {
                System.out.println(Thread.currentThread().getName() + " 到达屏障点...");
                try {
                    barrier.await(); // 等待其他线程到达屏障
                } catch (Exception e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName() + " 继续执行...");
            }).start();
        }
    }
}

```

# 信号量Semaphore， 用于控制并发，如果只有1个许可，就是锁
acquire(): 获取许可
release(): 释放许可，增加可用许可
```java
import java.util.concurrent.Semaphore;

public class SemaphoreExample {
    public static void main(String[] args) {
        int threadCount = 5;
        Semaphore semaphore = new Semaphore(2); // 允许 2 个线程同时访问

        for (int i = 0; i < threadCount; i++) {
            new Thread(() -> {
                try {
                    semaphore.acquire(); // 获取许可
                    System.out.println(Thread.currentThread().getName() + " 获取许可，开始执行...");
                    Thread.sleep(2000);
                    System.out.println(Thread.currentThread().getName() + " 释放许可...");
                    semaphore.release(); // 释放许可
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }).start();
        }
    }
}

```