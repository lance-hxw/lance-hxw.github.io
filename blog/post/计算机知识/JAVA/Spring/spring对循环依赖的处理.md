# 三级缓存
- singletonObjects: 实际容器,存放实例化且初始化好的实例
- earlySingletonObjects: 
	- 如果bean被aop代理,多保存一个代理bean实例
	- 无论如何,这里的目标bean实例都是半成品, 没有初始化
- singletonFactories
	- 存放对象工厂,传入匿名内部类, 
	- 这工厂调用getEarlyBeanReference,将结果存入二级缓存
是三个map

## A依赖B, B依赖A, 如何创建
- 尝试在一级缓存找A, 不存在, 开始实例化A
- 先在三级缓存添加一个(A, 创建方法), 此时就有内存地址了
- 现在 尝试为A设置其属性B
	- 从一级缓存找B, 不存在, 开始实例化B
	- 在三级缓存中添加(B, 创建方法) ,B有内存地址了
	- 尝试为B复制属性A, 此时找到三级缓存中有A, 将A放入二级缓存, 删除三级缓存, 使用A初始化B
	- B初始化完成, 所以将B放入一级缓存, 删除二三级中的B
- A得到B, 从二级缓存移动到一级缓存
# 为什么要三级, 不能两级?
和动态代理有关系,
如果有代理, 从三级缓存中找依赖时, 会获取一个代理对象的bean, 否则用原始bean
如果去掉三级缓存, 那么一创建就得放二级缓存, 不能延迟实例化
而且, 此时, 如果BC都依赖一个没有初始化的有代理的A, 那么会获取不同的A的代理对象