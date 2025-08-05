需要被通过网络传输，或者持久化的对象都需要实现Serializable接口
serialVersionUID是类的唯一标识符, 也能标识序列化的版本控制

## 序列化的作用
- 可以通过对象io流在不同jvm之间传递对象
- 可以用消息队列或者网络进行通讯
- 使用远程方法调用（RPC），实现调用远程jvm上对象的方法
## 序列化框架
java默认框架有很多缺点
- 不能跨语言
- 不安全，对象通过objectinputStream用readObject反序列化，他可以将所有对象都实例化出来，可以执行任意能读取的类，没有任何限制
- 序列化结果太大
可以用FastJson，Protobuf等
Protobuf性能高
## 具体如何写
- 首先让类实现Serializable接口，并且所有成员都需要serializable
- 然后创建一个ObjectOutputStream，将对象用writeObject（）写进去
- 然后用ObjectInputStream用readObject将对象读出来