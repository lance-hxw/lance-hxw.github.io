主要分两类，字节流和字符流
字节流：FileInputStream
- 处理原始二进制数据
- 核心抽象类是InputStream和OutputStream
字符流：FileReader
- 处理文本
- 核心抽象，Reader和Writer

# 流式读取对象
## 对象首先要实现Serializable
- 如果某个字段不需要被传递
	- 设置transient关键字，序列化时会忽略
	- 反序列化得到默认值
- serialVersionUID，用于保证版本
- 序列化是递归处理的，所有成员都要实现
## 序列化读写
- java.io.ObjectOutputStream
- java.io.ObjectInputStream