参考dubbo，服务调用过程为：
- 持有proxy对象，发起调用
- proxy获取网络client对象，与server通讯
	- 进行协议header的codec
	- 进行协议body的serial
- server进行dispatcher，交给handler
	- handler交给executor
	- 最终找到impl完成调用

# client
# server
# core

## 消息协议

## 编解码器

## 工厂方法
- 单例控制
- 注册中心工厂
## 代理工厂：给client获取代理对象
- jdk动态代理
- [ ] javaassist
- 实现自己的invocationhandler
- 将invoker抽象出来，handler的invoke最后去调用invoker的invoke方法
```markdown
执行逻辑：
- 将运行时参数存到Object数组
- 使用InvocationHandler的invoke方法
- 将执行结果返回
需要实现：
- 自定义InvocationHandler，即invoke
```
## 注册中心
### 服务注册
- 本地注册：serviceName+version : serviceImpl.class
- 远程注册：seviceName+version : url
### 服务发现
- 获取服务url
### 其他：
- [ ] 是否需要健康检测
- [ ] 主动下线
## 增强模块
### 负载均衡：用于代理工厂
- RoundRobin
	- [ ] 加权轮询
- Random
	- [ ] 加权随机
- [ ] 一致性hash
- [ ] 最小连接数
### 序列化功能：支撑编解码器