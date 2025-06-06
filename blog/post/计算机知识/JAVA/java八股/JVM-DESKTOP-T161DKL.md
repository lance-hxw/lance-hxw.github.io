![[Pasted image 20250220162524.png]]

jvm内存：
- Managed Mem: jvm申请并管理
	- heap
	- stack
- Native Men: jvm申请但是操作系统管理
	- meta space
	- 直接内存：如NIO
	- 本地方法stack

# hotspot JVM
## 元空间 metaspace
存类的元信息
即方法区Method Area的实现，在8后替代了PermGen
metaspace使用本地（直接）内存而不是java heap
- jvm规范只说了要存meta信息，没规定存在哪
- 永久代在heap里，被取代了。
## java 虚拟机栈 VM stack
每个线程有一个私有独立的栈，随着线程创建，里面是栈帧：
- 每个方法执行都创建一个帧
- 存放局部变量表，操作数栈，方法出口等信息
- 可以固定也可以动态
方法执行完，这个帧就被删除，不需要垃圾回收
## 本地方法栈 native method stack
类似虚拟机栈，但是执行本地方法，jvm规范中允许自由实现。
## PC 程序计数器
可以看作当前线程执行的字节码的行号， 在一个时刻，一个处理器只会执行一个线程中的一条指令，每个线程都会有一个独立的pc，这个部分是线程私有的。

## Heap
所有线程共享，虚拟机启动时创建，实例对象和数组都在heap上。
可以通过GC回收
jdk8后，字符串常量池和运行时常量池从永久代中剥离出来
## 直接内存
NIO是一个基于通道和buffer的IO方式，可以用native函数库直接分配到heap外的内存，然后用一个存在heap中的缓冲区对象作为这块额外内存的引用并利用。这能提高性能，不需要反复在heap和native heap传输数据

# 细节
## stack vs heap
- 栈存临时变量，heap存对象和常量池
- 生命周期： 周期明确，自动销毁。heap中不确定，需要GC
- 存取：stack更快，LIFO，简单快速，heap慢，需要分配和回收机制
- 空间： stack小且固定，是操作系统管理，heap大且动态，jvm管理。
	- 溢出：递归或者局部变量太大； 大对象太多
- 可见性： stack是私有的，heap是共享的
## stack存储内容
- 由于所有对象都在heap中，stack中的那些局部变量如果涉及对象，其实都是引用
- 即： stack只有对象引用和基本数据类型，引用指向heap，并且还有常量池，也是引用。（如果是常量的基本类型，还是值）
## heap的内部
一般划分为：
- 新生代：1/3
	- Eden space： 比较小
		- 新创建对象
		- 满了就出发MinorGC
	- Survivor space：分成两个等大区域S0和S1
		- 每次MinorGC后，存活对象被移动到一个s区域
		- 这两个区域是轮流中转的
			- 用于区分短暂存活和长期存活对象
		- 每次GC后新生代的中的对象：
			- 如果在Eden，去S区域或者老年代
				- 如果S区域满了就直接去老年代
					- 一般不会
			- 在两个S区域轮转，年龄+1
			- 轮转中达到Tenuring 阈值，进入老年代
			- 大对象可能直接去老年代
- 老年代：2/3
	- 存放经过minorGC后还活着的对象
	- mayorGC/Full GC 比较少执行，并且执行耗时非常大
曾经有PermGen，移除了
有的jvm实现（G1垃圾收集器）中有大对象专用空间，如大数组，这种会直接被分派到老年代，不用连续移动和分配内存。


## java一个方法执行过程：
- 解析方法调用，通过符号引用找到实际方法内存地址（如果还没解析过
- 调用前创建帧
- 执行方法内的字节码指令， 从metaspace获取
- 返回结果，清除帧
## 常量池
### 运行时常量池 meta space
meta sapce 中，以前在永久代
存储，**类文件**中的常量池，被类加载器解析后得到的符号引用，方法引用，数值常量
可以动态添加常量，如String.intern
### 字符串常量池 heap
以前在永久代，现在在heap
便于垃圾回收，即String对象
### 类文件常量池 在class文件中
这个是值存在class文件中的常量内容，包括字面值和符号引用，等待类加载进如Runtime constant pool

## 方法区/meta space内容， 根据jvm规范
### 类的元信息
- 完全限定名FQCN（.连接的类名）即符号引用，访问修饰符，父类信息，实现接口信息
- 类加载时进入meta space
### Runtime Constant Pool 加载自class文件的各种常量
支持动态添加
### 字段信息 field info
- 类中的字段（包括静态变量）和修饰符信息
### 静态变量
- static修饰的类变量在方法区
- 基本类型在这里, 对象的话,只是持有引用.
### jit编译后的代码
- hotspot中，存一些本地代码
- 就是在解释字节码过程中，发现的一些常用字节码，编译成本地代码反复使用。
### 方法的字节码
- 类加载器从class文件中加载到metaspace
### 其他
- 常量池缓存Constant Pool Cache（特么的，这个就是上面两个常量池，是一种思想或者概念），提升类加载效率
## 字符串常量池
如果你String str = “xx“， 这样是在常量池中创建一个常量，
如果String str = new String（”xx“），同时在常量值和heap中创建一个String对象
注意：
- 所有的字符串都是String对象，无论是在常量池还是heap
- String里面有一个final的byte数组，这个底层数据可能是共享的
- 常量池的关键就是提供这个底层数据，而不一定是同一个String对象。
- 如果你用intern方法，就一定返回一个常量池中的String
即，不用new可以节省内存
## 引用类型
### 强 引用
- 赋值方式的引用，有强引用的不会被GC
### 软 引用
- 有用但不必要，如果要溢出了才会GC
### 弱 引用
- 对象下次就一定会被GC
- 性质是”无代价（自动GC）“，有引用的效果
- 用途： 创建非强制的对象引用
	- 缓存系统
	- 对象池（也是缓存），如果对象没有强引用了，还可以放一会
	- 避免内存泄露，保证不被长期保留
- 可以使用WeakReference\<T> xx 实现，这并不是强引用。
	- 获取用xx.get()
	- 当对象被清理了，这个xx会变成null， 需要再次赋值。
### 虚 引用
- 幻影，必须和RefQ一起用，一定会回收，可以管理堆外内存。


# 常见内存溢出/泄露
## 泄露
不被使用的对象还在被引用，导致GC处理不掉
来源：
- 静态集合，里面存了一堆东西
	- 这个集合类在GC里面不会被清理
	- 引用的对象在heap里也释放不掉
- 监听，一直监听某个对象，一直引用
- 线程，线程停不下来，一直引用
## 溢出
jvm内存不足了
来源：stack溢出、heap溢出、metaspace溢出，直接内存溢出
- stack： 递归太长
- heap：引用不释放或者大对象，gc决定不处理
	- 静态集合也会导致这个
- meta space： 动态代码生成了太多类，或者加载了太多包
- 直接内存：IO缓冲溢出
## 静态相关的解决方法
- 少用静态
- 单例模式使用懒加载
## ThreadLocal 导致的问题
# 逃逸分析
在JIT阶段,如果判定一个对象不会逃逸出当前方法或者线程,就可以进行优化:
- 可以直接在stack中分配对象,不在heap分配,提高性能,减少GC压力
- 标量替换:直接把一个对象的成员解析出来变成类似符号引用的局部变量,比如p.x和p.y, 都存成局部变量, 直接不创建p对象
- 同步消除, 直接去除sync. 
jvm默认启用逃逸分析, 但可以禁用:
- -XX:-DoEscapeAnalysis
局限性:
- 不是所有对象都能优化: 太复杂,就算不能逃逸也难以优化
- JIT(C2编译器)运行时决定, 纯解释执行下不优化
- 不能代替GC

# JVM client模式和server 模式
这是jvm的两种不同运行模式, 主要区别在与JIT优化和运行时性能调优
## Client
轻量级应用
- 优化了启动速度, 适用于短生命周期的app
- 编译优化少, 用更简单的C1编译器, 效率低, 但是编译启动快
- 单核, 没有多线程优化
## Server
长期运行, 高性能app, 如web后端, 数据库,
- C2编译器, JIT 深入优化
- 启动慢
- 多线程, 多核

# 其他概念
## PermGen space
只有hotspot中才有，其他jvm中没有，永久代，是jvm规范中方法区的具体实现。
由于方法去存类的相关信息，如果类是动态生成的，就会出现永久代内存溢出。
大小是固定的，
