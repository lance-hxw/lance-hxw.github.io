# 入口
执行SpringApplication.run(app.class, args);
进行app初始化
 - 检测加载META-INF，中的自动配置类
 - 初始化应用类型
 - 注册监听器和事件等
# 环境准备
- 加载配置文件
- 处理环境变量，参数等
- 创建一个Env对象封装相关信息
# 创建应用上下文
## 实例化ApplicationContext（I O C）
- 根据应用类型选择上下文实现
- 然后初始化Bean工厂，
- 实例化BeanDefinitionReader加载Bean定义，生成BeanDefinition对象
- 实例化ClassPathBeanDefinitionScanner
## 注册Bean定义
- 扫描注解标记
- 处理配置类
# 刷上下文
每次刷新都会销毁容器重新创建，不能在生产环境去刷
每次bean创建完，容器就固定了，不能加新的bean
## 激活ApplicationContext
- 调用refresh触发初始化操作
- 实例化并初始化所有非lazy的Bean单例
- 处理Bean的DI和AOP
## 启动内嵌服务器（tomcat, netty)
# 事件发布
## 触发启动事件
启动开始
上下文刷新完成
应用就绪
# 自定义逻辑
- run里面的启动后逻辑
- Bean特殊生命周期
