# adapter

## mproto：用于和mongo映射



## proto：用于通讯的结构体
定义proto然后生成pb.go文件， proto在别的语言中也能生成
不过似乎只有event_action_pb.go中用到了protobuf

# gateway
## 具体controller
就是继承ctrl.Controller， 实现对不同action的处理
（engine中用命令模式+Commands注册实现）
service中是 直接用switch do case 去调用具体方法

在controller中与包同名的文件中定义了controller，其中一般包含几个api adapter类用于调用下游服务（如果需要的话）

具体方法

# service


- 有的是在controller的init里写路由然后在service 的main直接init， 有的是分布在每个controller中
- 有一些服务是内部服务， 没走gateway，直接被前端那边调用了，api文件还没改
- 