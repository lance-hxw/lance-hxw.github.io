具体实现中, 对于一个给定的location, 一个ant风格的地址字符串, 尝试使用若干个protocal 解析器, 进行加载, 加载不出来就使用一些默认的加载器进行, 最终返回一个Resource对象

ResourceLoader还维护了一个ClassLoader, 可以直接返回
这个ClassLoader可以用于方便的加载classpath中的资源, 如jar包中的
- 如bean, 和其他类
- jar中的图, 等资源
- 配置文件

这个classLoader是创建resourceLoader的当前线程上下文的classLoader
如果是null, 就用加载resourceLoader的加载器

