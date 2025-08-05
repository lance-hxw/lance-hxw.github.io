rpc和http都是应用层协议

rpc一般更定制化, 性能好一点
http是同样的, 所以给客户端用更方便

不过在http1.1, rpc还有性能优势(精简报文)
但是http2时代, 这玩意性能比有的rpc还强, gRPC直接就用http2实现的
