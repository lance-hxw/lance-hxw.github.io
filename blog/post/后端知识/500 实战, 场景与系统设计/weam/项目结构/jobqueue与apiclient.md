jobqueue是一个封装好的， 并发作业队列，可以进行并发控制等操作
具体使用中， 可以用于rpc调用
其中的newclient是xclib的apiclient包中定义的
与老client区别？
# apiclient
这是一个基于http的rpc client，通过类似命令模式的方式， 
主要功能是集成了服务发现注册机制
server是jobmanager
## apiclient结构体：作为rpc的入口
成员字段：
- AppHost：直接指定地址
- AppName：服务发现
- AppKey AppId（用于认证？
- TracingCtx context.Context: 传递OpenTracing上下文， 用于追踪
- userServiceDiscovery bool ： 决定是用服务发现还是固定host
- newClient newapiclient.APIClient: 持有一个apiclient实例
	- 在svcdiscovery包的init中， 设置了使用newClient为true
		- 即使用apiclient包里的client进行rpc
	- 在封装好的application包中的Init中， 调用了svcdiscovery的init
		- 但是在V3版本中， 实际根本没用
		- application的init中调用了apiclient的init
			- 但是没什么内容
	- service中使用了application启动
		- application的init中有一个switcher作为功能动态开关
			- 其中一个就是是否启用nc（newclient
			- 目前配置是打开的
			- 另一个是offline（服务健康离线检查
	- engine中似乎直接用的httpserver，没用用application
		- 但是engine是直接用的apiclient没用jobqueue， 所以两个服务都是用的newapiclient
[[new apiclient]]


成员方法：
- addMetric
- Do（核心方法， 里面调用具体的do， 具体do里面用sendrequest去
- nsDo，不用name的do
- proxyDo，
- 若干个DoRaw
- SendFile
- SendRequest
- 

辅助方法：
- 基于SD(服务发现)新建apiclient
- 基于配置新建apiclient
- buildurl等工具方法

# new apiclient
使用xclibc中的apiclient包，其中实现了apiclient复用等路径哦