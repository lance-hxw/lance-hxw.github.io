# Context 结构体
主要成员有:

## http部分:
- ResponseWriter, 响应写入器
	- 自己封装的, 有写入状态跟踪等功能
- Req: 来自标准库的http请求对象
	- 里面包含请求路径, 方法
	- 一个Response
	- 一个context.Context
- Session: 会话管理
- Keys: 一个kv存储
- Params: URL 路径参数, 直接使用httprouter.Params

## 框架功能部分:
- Engine: 框架引擎
- writer: 底层写入层
- handlers: 请求中间件链
- controllers(type): 控制器类型信息
- index: 中间件执行索引
## 安全部分
SessionKey , 会话密钥

## 渲染htmlEngine, 可选,
## 链路追踪
tracingCtx context.Context: 分布式追踪上下文
traceBody, 自定义追踪信息, 包含请求id, 调用链, 客户端id等