aop基于动态代理
默认情况下， spring对有接口的使用jdk代理，没有实现接口的， 用cglib

在springboot2+，所有aop都默认用cglib， 可以避免没有实现接口的问题。