是一个实现了mvc设计模式的请求驱动类型的轻量级web框架

级分成model, controller , view三层

其中后端主要关心controller(请求) + model(业务)
view层相当于controller返回的数据


主要注解

@RequestMapping 注册对应路径的controller