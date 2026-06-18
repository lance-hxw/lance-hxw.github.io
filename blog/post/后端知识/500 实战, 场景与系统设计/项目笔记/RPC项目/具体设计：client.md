client发送的数据：invocation对象
接收：Object对象，自己处理成returnType

注意，使用责任链模式注册的时候，发送invocation是主线程里写的，然后异步等待
# 实际需要处理的逻辑：
提供send方法
- 参数：hostname， port， invocation， returnType， serializer
- 返回：一个returnType的对象
其中执行：
- 连接到server
- 发送数据
- 接受响应

# netty client
- 首先缓存连接池，为每个hostname port 创建一个连接池
- 然后请求来的时候去连接池拿连接
- 在send方法finally中释放连接