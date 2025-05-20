spring boot 提供的定时任务, 定时执行操作, 在spring-context模块下提供
使用@EnableScheduling注解开启功能, 并在方法上使用
@Scheduled()注解实现定时任务
- 默认情况下, springboot的定时任务是单线程执行的
缺点:
- 单线程阻塞
	- 阻塞完很可能再阻塞下一次, 引发连锁反应
## 快速上手
- 定义一个bean
- 使用Scheduled注解
- 指定定时执行策略
	- cron
		- cron表达式
	- fixedDelay
		- 根据上次任务结束开始记时, 和逻辑无关, 间隔恒定
	- fixedRate
		- 两次开始时间保持一致, 但是不能并行
		- 如果上一个任务超时, 会阻塞下一个, 上一个执行完立即执行下一个
- 还有个特殊属性, 只用于两个fixed策略, initialDelay, 第一次延迟执行的时间, 对cron无效
	- 如@Scheduled(initialDelay=5000, fixedDelay=1000)
