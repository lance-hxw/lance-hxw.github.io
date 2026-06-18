主要方案有：
- clusterIP + DNS
- service mesh

## cluster IP + DNS

下游服务需要注册自己，即需要在配置文件中
配置spec.selector中的匹配lable，到相关服务名上

上游服务需要自动用DNS找相关服务，此时只需要用相关服务label的url去访问就行， dns会自动解析分流到对应服务


## 需要自己负载均衡等策略（如gRPC）
可以关闭， 即spec.clusterIP = None
此时对相关服务的DNS查询会返回多个Pod IP


## service mesh
使用sidecar处理通讯