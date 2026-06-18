主要涉及概念
- futureTask
- completeableFuture
- 线程池

## 直接使用线程/线程池执行
直接执行
即pool.submit(() -> func());

## Future/Callable/CompetionService
需要结果

## CF

```java
ExecutorService ioPool  = new ThreadPoolExecutor(50, 200, 60, TimeUnit.SECONDS,
    new ArrayBlockingQueue<>(1000), r -> new Thread(r, "io-"));
ExecutorService cpuPool = new ForkJoinPool(); // 或 new ThreadPoolExecutor(NCPU,...)

CompletableFuture<User>  userF  = CompletableFuture
    .supplyAsync(() -> userApi.getUser(uid), ioPool)
    .orTimeout(300, TimeUnit.MILLISECONDS)
    .exceptionally(ex -> fallbackUser(uid));

CompletableFuture<List<Order>> ordersF = CompletableFuture
    .supplyAsync(() -> orderApi.listOrders(uid), ioPool)
    .orTimeout(500, TimeUnit.MILLISECONDS)
    .exceptionally(ex -> Collections.emptyList());

// CPU 密集处理放在 cpuPool
CompletableFuture<Report> reportF = userF.thenCombineAsync(ordersF, (u, os) ->
    heavyComputeReport(u, os), cpuPool);

Report report = reportF.handle((r, ex) -> ex == null ? r : defaultReport())
                       .join(); // 业务端决定 join/get 的位置

```

## reactive


## java 21, 虚拟线程
使用虚拟线程执行器， 提交后获取一个Future对象，后续get就行

## spring 异步
使用Async 将方法提交到指定executor，方法返回值是CF
