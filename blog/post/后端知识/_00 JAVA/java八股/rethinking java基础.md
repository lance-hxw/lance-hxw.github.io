## 1. JVM
java virtual machine 是虚拟计算机，是java跨平台的基础
jvm有hotspot（oracle&openJDK），openj9，android Runtime
### 1.1 Class Loader 类加载器
包括: 
- bootstrap classloader, 加载核心java类库
- extension->platform classloader, 加载扩展类库
	- 父加载器是bootsrap
	- jdk 9后，替换成platform
- system = app classloader, 加载用户类路径ClassPath上的类，是默认类加载器
	- system classloader父加载器是extension
	- app classloader 父加载器是platform
- 自定义类加载器，可以从各种来源加载类，比如别的进程送来的。
其过程是通过一个类名去加载类数据, 然后用类名和数据定义类

#### 双亲委派机制
每个加载器都优先让父加载器完成，除非父加载器找不到
优点：
- 保证唯一性，所有加载请求都过了bootstrp，然后有序进行，防止加载重复的类
- 安全性： 防止核心类库被加载错或者替换
- 支持隔离和层次划分
	- 各个层级职责清晰，便于维护
- 简化加载流程，效率高，不混乱，每个加载器只需要处理一部分数据
#### 类生命周期
- 加载， 通过名字找到class文件， 创建一个Class实例
- 连接：将Class和字节码链接
	- 验证： 验证class文件合法
	- 准备：分配内存， 创建静态变量
	- 解析：符号引用变成直接引用
- 初始化，执行*类构造器方法*， 这是class类型的构造器，不是实例构造，是编译器自动生成的。
- 使用
- 卸载：所有实例都被回收，加载该类的ClassLoder被回收，Class实例不被引用，就会被清理。
### 1.2 runtime 数据区
- 方法区: 存储类信息, 常量, 静态变量等
- Heap: 存对象实例，类Class对象
- Stack: 存局部变量和方法调用，类数据结构
- 程序计数器: 当前线程执行的字节码位置
- 本地方法栈: 执行本地方法服务

### 1.3 对象
- 对象头
	- Mark word
		- hashcode，GC分代年龄，锁状态
	- Class Pointer
		- 指向实例的类对象，支持动态类型检查和方法调用
	- 数组长度
- 实例数据
	- 即成员变量
- 填充
	- 对象需要按字节对齐，所以对象头末尾有一些padding
		- 整体是8B的倍数

每个对象在jvm中都有一个对象头，包含了类指针和锁信息，在hotspot jvm中， 是对象内存布局的一部分，存了hashcode，gc信息，类型指针和锁。
对象头由MarkWord和Klass pointer构成，对于数组，还有个长度字段。
- MarkWord： 标记字段：对象运行时数据，hashcode，GC，锁
- KlassPointer：类型指针：jvm通过这个指针识别对象的类型， 方法和属性
	- 指向堆中的一个Class对象
- 数组长度。

#### 创建对象过程
- 加载检查，metaspace中有没有该类元信息
	- 如果没有， 开始类加载
- 分配内存
- 初始化0值，除了对象头，全部变成0
- 必要设置，如对象头的Class指针， MarkWord配置（hashcode，gc age，lock）
- 执行init方法，在上述方法结束后jvm**已经**出现了一个新对象。
	- 但是对象构造函数刚开始执行，即class文件中的构造方法没执行
## 2. 内存管理
### 2.1 垃圾回收:GC
#### new出的对象生命周期
new出的对象是GC负责回收，周期检测不被引用的对象
具体的，回收策略有：
- 引用计数：对象引用为0表示可回收
- 可达性分析，从根对象（静态的）出发在引用链上遍历，检测可达性
- 终结器：如果对象重写了finalize（），GC会在回收前调用此方法，进行特定的析构，但是这不被推荐，执行时间不确定，有性能问题。
### 2.2 内存分配策略

## 3. Reflection 反射
优点：动态信息访问， 对象创建，方法调用，修改访问字段值（无视修饰）
允许程序在运行时修改和检查程序的结构和行为:
- 获取类信息, class = Class.forName(Name), .getDeclaredMethods()
- 创建类实例, obj = class.newInstance()
- 调用方法 method = class.getMethod("name",String.class)
- 修改/访问字段
- 操作注解
注意
- 反射调用会更慢, 可以用setAccessible(true)
- 只应该在框架开发中用, 不要在业务中写
比如， 获取注解的参数
```
methodSignature.getMethod().getAnnotation(AutoFill.class)
```
### 反射的应用
其动态性决定了他在配置注入的作用
- 加载数据库驱动，此时通过反射将驱动配置注入程序
- 配置文件加载
## 4. 类加载机制
类加载器从文件系统，网络等途径加载class文件
会从：
- classpath
- jar文件
- 网络
中尝试加载
### 4.1 加载过程
- 加载, 查找字节码, 创建Class对象
- 验证: 保证字节码安全
- 准备: 静态变量分配内存
- 解析: 符号引用转直接引用
- 初始化: 执行静态块, 初始化静态变量
### 4.2 双亲委派
- 子加载器把请求委派给父加载器
- 防止重复加载
- 保证安全
### 类加载器层次结构(自底向上)
- Bootstrap 底层加载器，加载核心类库
- Extension，加载jre中的lib/ext下的类库
- System ， 加载用户级别的路径，如classpath
- Context，每个线程都有一个与之关联的上下文类加载器，这个加载器是父线程或者容器定义的。
## 5. Class对象
是描述和表示类的元数据的特殊对象, 是反射的基础.
当定义一个类时, jvm创建一个Class对象	
如何获取Class对象:
- Person.class //类的.class语法
- person.getClass() //实例的getClass()方法
- Class.forName()方法
用途:
- 获取类信息, 通过getMethods,getDeclaredFields,getConstructors
- 动态创建对象, personClass.newInstance()
- 判断类型, 将一个实例的Class和一个类的Class直接对比是不是同一个
- 获取修饰符，使用getModifiers， 这个是一个int
### 重点特性:
- 每个类在jvm中只有一个Class对象， 所以可以用于类型比较
- 类加载时自动创建
- 不可变
### 创建实例的方法
- new MyClass
- （MyClass）Class.forName("com.xxx.MyClass")， 然后用newInstance方法
	- 类加载器从多个来源加载。
- MyClass.class.getConstructor().newInstance();
	- 默认是无参构造
	- 若有多个构造需要指定，需要用String.class，这样去指定类型信息。
- clone
- 反序列化，用对象流获取object后强制转换
```java
ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("object.ser"));
out.writeObject(obj);
out.close();
// Deserializedobject.java
ObjectInputStream in = new ObjectInputStream(new FileInputStream("object.ser"));
MyClass obj = (MyClass) in.readobject();
in.close();
```