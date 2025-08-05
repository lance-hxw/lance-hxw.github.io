首先bean没有线程安全设置， 但是受到scope影响

# singleton的bean
默认是单例bean， 且绝大部分bean都是单例
单例意味着，所有的对这个bean的请求都会访问这个bean实例
此时：
- 无状态bean是安全的，
	- 如没有成员变量，或者不能修改，此时只是方法的执行和查询操作
- 有状态bean是不安全的，
	- 此时涉及并发修改， 不安全
# prototype， request， session等scope
此时有不同的隔离程度，在一定范围内线程安全