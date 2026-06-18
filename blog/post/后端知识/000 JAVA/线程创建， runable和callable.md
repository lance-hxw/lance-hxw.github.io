在使用Thread创建一个线程时，可以接受一个runnable对象，
由于runnable是函数式接口，所以可以用lambda转换成，只要匹配方法签名
如果给thread的方法需要返回值，可以使用callable的，并结合future机制或者线程池。
如：
```java
ExecutorService executor = Executors.newSingleThreadExecutor();
Future<Integer> future = executor.submit(callableTask);
try{
	Integer result = future.gett()
}catch(InterruptedException | ExecutionException e) { e.printStackTrace(); }
executor.shutdown();
```
一个callable的接口也可以用lambda来复制，callable也是函数式接口，他只有一个抽象的call（）方法。

## 最大区别
Thread只能接收Runnable的实例
而Callable只能通过ExecutorService去调用，即通过submit获取future对象，因为可以有返回值

