# api

## 每个api文件包括
- 作为xxx_api包存在
- 里面有New(ctx context.Context) \*Api 方法
- 然后实现一个自己的Api实现类，内置一个client作为命令执行器
这个api实现是在具体command的exec方法中被调用的
client中定义了服务发现相关的逻辑
## api里还需要定义每个method对应的返回体结构等
# api_proxy
gateway中有一部分走这里来，api定义在api目录下的ugc api中
# bizcommon

# common

# document

# errcode
# gateway
## 基于命令模式进行处理
定义Command类型
```go
type Command interface{
	Name() string
	SetName(name string)
	ParseRequest(b []byte) error // 解析请求参数
	Exec(c ctrl.IResponsor, ctx *httpsvr.Context, et *elapsed.ElapsedTime) // 执行命令
}
```
### 路由管理
通过RegCommand方法注册命令
用一个Command map存储所有注册的命令
每个命令唯一名称
### 请求处理
ParseRequest：将http请求体解析成对应参数结构
Exec：执行具体逻辑
Name：命令的URL

接收到指定请求后， 找到对应的command，然后将请求体传进去，执行Exec

### 实现具体命令
一个具体命令是一个struct如下：
```go
type baseCommand struct{
	name string
	paramType interface{} // 请求参数类型？
}
```

在自己的init里面注册命令

controller是invoker， 他接收请求然后调用client去执行
每个invoker有自己的命令注册表
#### 每个具体controller中有
- Commands表
- ModelName（如account
- 继承ctrl.controller
	- 实现Post/Get等接口， 写好路由（根据请求路径去Commands里查
	- 这里写容错，解析等操作
	- 执行是执行一个Command对象的Exec方法
		- 一个具体的包中， 除了一个controller外，还有若干command定义
- 定义NewCommandFunc func() Command 这个函数类型
	- 每个Command实现自己的这个方法
- 定义Command和baseCommand
	- 似乎go就是定义和使用要在一起？
	- #TODO
- 实现RegCommand类，往Commands里注册
	- 其原型是 func RegCommand(newCmdFunc NewCommandFunc)
- 添加路由方法， 将这个controller注册到httpserver
#### 每个具体command
- init的时候RegCommand到controller
- 定义自己的NewCmdFunc, 名字就是methodName
- 实现Command类
	- 继承baseCommand，包括Name和paramType
	- 定义param（请求）和data（回复）并组装进去
		- param中包含了请求头和请求体数据
		- data中是对应api的里的一二
	- 实现Exec方法（逻辑写在doExec中
		- Exec中需要做：
			- 从ctx中填充ip，填充param， 设置响应data
		- doExec：具体逻辑
### 命令注册表
是一个map\[string]NewCommandFunc

# py_job

# service
每个具体的service中
## 用命令模式实现controller，提供http api

## models：db交互定义

## dao层
使用model层的方法实现功能
## 涉及的service层写到service/logic里面
每个具体category实现一个service包，维护service单例
### logic包
具体逻辑

logic包中：
- 一个和该category同名的st，持有一个dao层的store
- 然后logic中的方法全部定义在这个st上
### method go
将service中的方法映射到logic中去
### service go
实现：
- 限流功能
- 配置db
- 到这里进行响应市场的check，大出slow log
# SQL
？
# ugcproto
这里直接定义了各种msg， 各种结构体， 不是用proto生成的
“内部服务， 不需要暴露出来"
"不考虑跨语言序列化问题"

