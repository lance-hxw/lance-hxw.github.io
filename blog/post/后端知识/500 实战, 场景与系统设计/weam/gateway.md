主要基于
- xclib中封装的application作为app模板
- 封装的一个httpsrv， 作为server
- 一个封装的controller类 作为父类去实现后续controller

# main
初始化相关依赖
设置httpserver
注册路由
配置注册中心
配置服务发现

获取端口后， 启动server