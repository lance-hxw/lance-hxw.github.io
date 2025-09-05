http长连接

在http通讯前， 首先是tcp三次握手

建立tcp连接后

- 若为https， 还需要进行tls握手

client发出http请求， server响应

长连接本质就是， 每次请求是否需要去创建一个新的tcp连接

# 转换协议

使用http 101 Switching protocols状态码可以实现协议升级

如：
client 发起升级：

GET /websocket HTTP/1.1
Host: example.com
Connection: Upgrade
Upgrade: websocket
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13

server响应：

HTTP/1.1 101 Switching Protocols
Connection: Upgrade
Upgrade: websocket
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=


# 应用层协议如何与tcp长连接绑定

## 如何识别和复用tcp

linux使用socket文件描述一个tcp连接， 并为每个应用维护连接池， 每个连接用四元组表示

发请求时， 会检查是否有可以复用的连接

## linux如何识别长连接

在linux内核中， 会维护全部的tcp连接表
并可以查看tcp状态

linux不知道这是一个“长连接”

但是应用会一直持有socket不断开， 即不close(sockfd)
而tcp状态始终保持ESTABLISHED


## 何时断开？
应用管理， 应用调用close才会断开tcp