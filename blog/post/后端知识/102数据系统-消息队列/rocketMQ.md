# 服务架构

同样采用两个逻辑分层: 引擎层+proxy层

主要支持的协议有:
- 基于原生二进制协议
- 使用gRPC协议包
- OpenMessaging
- CloudEvents
- MQTT 在5.0引入
- AQMP还在准备支持中
# 网络io

主要协议: remoting原生协议, 基于netty实现的二进制协议, 宣称高性能低延迟

还可支持gRPC和HTTP/REST