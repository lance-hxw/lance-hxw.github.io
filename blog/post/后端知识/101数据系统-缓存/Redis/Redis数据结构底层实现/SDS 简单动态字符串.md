Redis的String的底层实现是S D S， 简单动态字符串，而不是传统C字符串
在redis中， SDS既要为用户提供String对象的实现，又要在redis程序内部作为char\*类型的替代.

- 替代char\*, 这里是显然的, 朴素char字符串功能太少, 需要更高级的实现, 提供更丰富功能
	- 在redis中, 几乎所有的字符串类型值传递都是基于sds的
- 用于实现String对象
	- redis中的所有Key都是一个字符串对象, 包含一个SDS值
	- value中, 一个包含字符串值的String对象也包含一个SDS
		- redis中的String可能存的是一个long等别的值
## 实现
- char\*
- struct sdshdr:
	- int len // 总空间长度
	- int free // 剩余空间
	- flags： sds 类型
	- char buf \[] //实际存储的东西
即, 使用了一个结构体, 用于优化

## 为什么能优化
### 在追加时
追加时, 会翻倍请求空间(), 常见的预分配优化

### 长度计算
使用len-free, 这是显然的

### 其他sds 的api, 在redis中

## Ref.
[Redis 设计与实现（第一版） — Redis 设计与实现](https://redisbook.readthedocs.io/en/latest/index.html)


