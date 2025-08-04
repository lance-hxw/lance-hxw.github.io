# 对比同步IO和NIO
如果纯同步调用，大量阻塞，不能接受
为了减少阻塞，就要回调，就会导致回调地狱
- 即为了利用另一个异步接口
如果使用线程池异步调用，会有线程调度的问题

## 解决：NIO，无阻塞
- 使用RPC中的异步调用
- 使用CF编排业务流程，降低依赖中的主色

# 横向对比
- Future不可组合，不能融合，不能延迟执行和回压
- RxJava和Reactor要好一些
- CF简单，易用，支持异步和组合
# 主要接口
## 创建
runAsync：异步执行，run类型，无返回值
supplyAsync：异步执行，supply类型 有返回值
completedFuture(U value): 一个已经完成状态的CF，直接给结果，不用函数复制
failedFuture（Trowable ex）：一个失败的CF，带有异常
## 转换和处理
thenApply(Function),接受一个，返回一个，返回新的CF
thenAccept(Consumer),接受一个，无返回值
thenRun(Runnable action), 无参数，无返回值

## 组合
thenCompose（Function extends CompletionStage），将当前cf的结果传给另一个返回CF的函数
thenCombine（CompletionStage, BiFunction) 结合两个任务的结果，两个都完成后执行指定任务（一个BiFunction
allOf（CFs），所有CF完成后，返回新的CF
anyOf（CFs），任意一个完成后，返回一个新的CF
## 异常处理
exceptionally（Function\<Throwable，R>)，发生异常时，提供替代结果
- CF.exceptionally(ex -> "?");
handle（BiFunction<T, Throwable, R> )
- 无论成功还是失败，都处理异常或者结果(自己决定)
	- CF.handle((res,ex) -> ex !=null? xxx :xxx))
## 手动完成：手动赋值，不带逻辑
compete（T value），手动完成任务并设置结果
completeExceptionally（Throwale）手动异常


# CF的状态：状态互斥，且单向，使用CAS和volatile保证状态管理线程安全
- 未完成：此时get会阻塞
- 完成：此时get立马得到结果
	- 可以手动complete
- 异常完成，结果是一个Exception
	- 可以手动completeExceptionally
- 取消，get得到一个Cancel异常
	- 可以主动调用cancel

# 如何使用
一个CF创建为
```java
CompletableFuture<String> cf1 = CompletableFuture.supplyAsync(()->{},executor);

需要指定一个callable/runable， 
和一个ExecutorService
如果是无返回值，用CF<Void>
```
组合：
cf1.thenCombine(cf2, (res1, res2) -> resFinally).thenAccept(Consumer);

### ExecutorService
可以指定supplyAsync的ExecutorService
如果不指定，默认使用一个ForkJoinPool执行器的commonPool执行
- 这个执行器是高效处理fork-join的，适合计算密集型任务
- 并行度一般是core-1
## 0依赖
即不依赖其他CF，此时有三种方式
- 使用ExecutorService，和supplyAsync，直接得到一个运行中的CF
- 使用completedFuture获取一个已经完成的CF，只能手动赋值
- new一个CF对象，然后手动执行complete
	- 典型场景：将回调方法先做成CF，然后再编排
	- 先new一个未完成的CF，然后作为回调函数当结果的包装
		- 可以用正常执行或者异常执行，去返回不同的值
### 如何创建一个带有逻辑但没有执行的CF：用一个Supplier包装，调用时返回一个CF
## 一元依赖：apply， accept，compose
使用thenApply,thenAccept,thenCompose
即
```java
CF2 = CF1.thenApply( result -> { return xxx;});
```

## 二元依赖：combine
```java
CF3 = CF1.thenCombine(CF2, (result1, result2)->{})
```

## 多元依赖：any/all
```java
CF6 = CompletableFuture.allOf(CF3, CF4, CF5);
CF7 = CF6.thenApply( v -> {
	result3 = CF3.join();// 此时不会阻塞，因为三个cf都已经完成了
	result4 = CF4.join();
	result5 = CF5.join();
	result = func(result345)..
	return result;
})
```

# CF原理
CF有两个字段， result和Stack， result存储这个CF的结果，Stack里面表示CF完成后需要触发的依赖动作，然后自动触发计算
stack是一个Treiber stack，stack就是堆头，是值为Completion类型的链表

类似观察者模式，依赖动作都封装在Completion子类，completion是观察者的基类

## 设计思想
### 被观察者
每个CF都是被观察者，一个stack链表存储注册的观察者
被观察者执行后，一次弹出stack并将结果通知
result存储返回的值
### 观察者
thenxxx这些会生成一个completion对象，如果cf已经完成，直接触发，否则进入stack

## 依赖情况
一元依赖时，CF2注册了观察者在 CF1上

二元依赖时，CF3在CF1和CF2上注册观察者，两个都完成了才执行CF3，不过CF1完成后就会发出通知，CF3只是暂不执行

多元依赖，构造成一个平衡二叉树，结果层层通知

# CF与ForkJoinPool
为什么契合？
- CF的异步经常产生树形依赖结构，FJP可以方便执行
- 工作窃取算法能负载均衡
- 轻量级任务调度（fork/join
- 并行度匹配多核（core-1
- 使用公用的执行器（FJP.commonPool
	- 减少资源浪费