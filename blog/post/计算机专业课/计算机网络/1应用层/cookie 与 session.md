
# 无法使用cookies的情况下如何存储session
存在SessionStorage 或者直接放到URL里，或者请求Header中，这个常用
# 分布式Session怎么做：
放到redis中
jwt
加密cookies
基于一致性hash，保证用户分配到相同服务器，但是故障或者改变时，需要迁移
nginx的session共享
基于微服务的session管理，使用spring session（基于redis）等方式实现
分布式session复制，通过复制机制实现