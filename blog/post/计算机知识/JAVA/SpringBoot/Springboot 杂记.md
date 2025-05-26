#springboot
## 注解 [[SpringBoot注解]]

## 杂记
- 开发者工具, 支持源码或者配置文件修改后, springboot应用自动重启, 只需要将spring-boot-devtools添加到pom 
	- 但是/static, /public和/templates等目录中的修改不会重启应用, 因为这些在禁用缓存时本来就是实时作用的
- springboot提供了一个maven插件spring-boot-maven-plugin, 可以方便的打包jar文件 
- 为了便于后端使用接口测试工具测试, 需要生成一个持久化的jwt
	- jwt配置中, 设定了token name, 按这个配置, jwt拦截器会从头中直接取出token来![[Pasted image 20241022143033.png]]
	- 我们用登录接口获取一个jwt后, 存在接口测试工具的参数中, 设置为tokenname就行.
		- 注意在apifox中, 首先在全局参数中设置 token 值为环境变量 {{token}}, 然后在具体环境中设置token
- 如果用的是query参数, controller中不需要用@RequestBody
- 数据库中的日期格式需要经过转换
	- 在java数据类的属性上加注解, 进行日期格式化
		- @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
	- 在WebMvcConfiguration中扩展SpringMVC的消息转换器, 统一对日期类型进行格式化处理
		- 默认带有很多个消息转换器, 需要将自己定义的加入list并放在最前面
- controller接受参数时
	- 路径参数在注解中使用/path/{arg}, 并用@PathVariable注解形参
		- /path/{arg}+@PathVariable, 这样要求arg和形参参数名一致
		- 如果形参和arg名字不同, 还需要用@PathVariable("arg"), 指定取哪个
	- query参数直接写在形参, 但参数名要一致
		- 涉及绑定问题
- mybatis动态sql, 注意条件判断中多个语句加 ","
- mapper应该是一个interface
- Controller参数匹配
	- 可以匹配到同名形参， 如username->username
		- 参数较多且和DTO同时使用时, 用@RequestParam指定
	- 可以匹配到DTO同名成员, 如username->xxxDTO.username
	- .表示法可以匹配嵌套成员, 如xxx.yyy->xxxDTO.xxx.yyy
	- 可以用@RequestParam("arg"), 指定绑定
- controller 传 DTO给service, service传实体类给mapper
	- service应该返回VO给controller
	- 特殊情况， 如， 多表查询， mapper可以传vo回去
- profiles:  active: dev 可以切换部分属性的环境
-  导入属性可以
	- 在configuration类中写Value
	- 定义一个Bean, 并加上ConfigurationProperties(prefix=)
		- 还有data
## SpringBoot额外功能
## 工具类
- DigestUtils
	- md5DigestAsHex(password.getBytes());# md5加密, 注意md5是单向, 不可逆的, 所以只能比对加密值
- BeanUtils
	- copyPorperties(a,b): a to b
- PageHelper

## 实践规范
### 常量: 所有值不能写在代码中, 要写常量中
- 错误信息封装到常量中
### 方法名

| operation | service             | mapper |
| --------- | ------------------- | ------ |
| 增         | add/create/insert   | insert |
| 查         | get/find/query/list | select |
| 改         | update/modify       | update |
| 删         | delete/remove       | delete |
