# 元信息：容器管理
- id :容器中唯一，在xml中，需要符合规范，即字母开头
- name：可以指定别名，并且支持多别名，使用逗号，空格或者分号分割
- class：指定实现类
- scope：定义作用域，常见取值：
	- singleton：只能有一个bean， 默认
	- prototype：每次请求都创建一个新的（原型
	- request，session：web
- lazy-init，控制是否延迟初始化（第一次使用时
- depends-on：指定依赖的其他bean，用于控制初始化顺序
- autowire，控制自动装配方式，默认byType，可以byName
- factory-method和factory-bean：指定创建bean的工厂方法和工厂bean
- parent，指定bean的父bean允许继承树形和配置

# bean与xml
bean用xml去定义，然后加载到容器中