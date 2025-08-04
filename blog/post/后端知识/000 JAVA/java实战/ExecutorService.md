ExecutorService接口继承了Executor，而Executor是一个只有execute（runnable）的函数式接口。
ExecutorService中主要增加了线程池生命周期，提交任务，获取Future等功能
主要方法：
- submit
- shutdown，但不是真的终止，只是说，等任务运行完，就终止
- awaitTermination，阻塞当前线程等待所有线程结束
## Future\<T> 接口主要方法：这个不能操作多个异步任务组成链式
- get()： 阻塞等待，会持续轮询isDone
- get(long timeout, TimeUnit unit)
- isDone
- isCancelled
- cancel()
```java
ExecutorService executor = Executors.newSingel...
Future<Integer> future = executor.submit(()->{
	return 42;
})
future.get();// 获取callable的返回值
```
## CompletableFuture，提供更强大的异步能力
- 支持回调thenApply，thenAccept（函数式编程）
- 任务组合（thenCombine，allof）
- 非阻塞获取结果：whenComplete
其使用的默认线程池是ForkJoinPool，也可以自定义线程池（只要是个ExecutorService
```java
CompletableFuture<Integer> future = CompletableFuture.supplyAsync(()->{
	// 异步任务
}, 自定义的executorService).thenAccept(res->{xxx});
```