# 标准输入输出流
即System.out/in 

# identityHashCode
返回给定Object的身份hashcode
Object自身的hashcode可能被重写，这个不会，始终用默认的hashCode

# 系统属性设置
可以获取虚拟机的系统属性
System.getProperty(String key)， 获取指定key的属性值
System.getenv(), 获取包含所有环境变量的map，也可以指定名称获取value

# Time
System.currentTimeMillis();, ms， 不是非常准确
System.nanoTime(), java虚拟机高精度时间源的当前值，ns

# ArrayCopying， 高效内存复制
System.arraycopy(Object src, int srcPos, Object dest, int destPos, int length)

# GC
System.gc(), 建议进行gc
System。runFinalization， 运行挂起终结的对象的终结方法， 建议

# 退出
System.exit(int status)
这个的优先级比finally还高

# 加载本地dll等
System.load(String filename)， 加载本地库
System.loadLibrary(String libname)， 加载链接库
System.console(): 用于读取密码
System.getSecurityManager,