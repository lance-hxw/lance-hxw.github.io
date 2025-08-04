线程池是为了线程复用实现的，其主要涉及的逻辑有：
- 创建线程池的参数
- 添加工作线程
- 阻塞队列
- 任务拒绝策略
主要涉及概念有：
- 核心线程：线程池中始终存活的线程数，即使不在工作
- 非核心线程：防止任务拒绝的临时线程，在空闲且经过一定时间后会被清理
# 初始化参数
- corePoolSize：线程池核心线程数量
- maximumPoolSize：最大总线程数量
- keepAliveTime：非核心线程空闲时间超过此阈值就会被销毁
- unit：kaTime的时间单位
- workQueue：工作队列，如果没有空闲的线程，就放入其中
- threadFactory：线程工厂
- handler：拒绝策略
# 执行逻辑：当一个任务交给线程池
- 首先检查有没有空的核心线程：
	- 如果有空核心线程，就让这个线程去执行任务
	- 如果核心线程已满，将任务放入阻塞队列
		- 如果队列没有满 ，就等待执行即可
		- 如果队列也满了：
			- 如果还没有达到最大线程数量，就创建非核心线程
				- 此时是从队列头取任务执行，
				- 将当前任务放到队列尾，这个过程是公平的
			- 如果已经达到最大线程数量，执行拒绝策略
# 拒绝策略
有四种预设的拒绝策略
- CallerRunsPolicy
	- 调用者执行，即让线程池的调用者所在线程去执行此任务
		- 除非线程池直接被停止或者有位置执行
- AbortPolicy
	- 直接抛出拒绝异常
- DiscardPolicy
	- 不处理，静默拒绝
- DiscardOldestPolicy
	- 把最老的任务抛弃，将当前任务加入队列
还可以自定义拒绝策略
# 线程池参数调节
new ThreadPoolExecutor(
	corePoolSize = 16,
	maximumPoolSize = 32,
	keepAliveTime = 10, // 设置为0不保留，立即清除
	TimeUnit.SECONDS,
	new SynchronousQueue<>(),
	new AbortPolicy()
)
## 核心线程数，线程越多，并发度越高
cpu密集型：cores+1，可以避免多线程竞争cpu（持久占用cpu
- 
IO密集型：cores X2， （短时占用cpu
- 如电商场景，高并发，短cpu用时
## 工作队列
new SynchronousQueue\<>()，不使用队列，直接扩张，只是传递
new ArrayBlockingQueue<>(1000),有界队列，容量1000
new LinkedBlockingQueue<>(200)，不指定就是无界的
还有优先级阻塞队列，也是无界的
## 拒绝策略
new AbortPolicy(): 异常
new CallerRunsPolicy(): 调用线程执行
new CustomRetryPolicy()


# 特殊参数情况
## 核心线程为0
此时只会创建非核心线程使用
## keepAliveTime为0
此时非核心线程一旦空闲，立马销毁

# 线程池种类 Executors内置四个线程池
- SingleThreadExecutor：唯一线程线程池，此时所有任务都会**按照提交顺序**执行。
- FixedThreadPool：固定线程数，只带一个缓冲区队列
- CachedThreadPool：无限的线程数，只用一个SyncQueue，容量是0，只是中转
	- 这个容易OOM，千万别用
- ScheduledThreadPool， 设置定期的执行任务，支持定期或者周期性执行任务
- SingleThreadScheduledExecutor，只有一个线程的定期线程


## 但是！请自行new ThreadPoolExecutor来用，而不要用预设线程池

# 阻塞队列选择
有界：指队列有容量上限与否
ArrayBlockingQueue，数组实现，有界
LinkedBlockingQueue，链表实现，可以有界也可以无界，默认无，但可以指定
SynchronousQueue，不存储元素，没有任何内部容量，只是用于传递任务PriorityBlockingQueue，带优先级，其元素需要实现Comparable或者提供比较器