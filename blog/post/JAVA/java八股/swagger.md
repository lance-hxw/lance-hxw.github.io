- 使用knife4j
- 在配置类中加入相关配置
	- 使用一个定义的函数扫描包中所有接口
- 设置静态资源映射
	- 把knife4j生成的文档直接映射到tomcat上的资源 
- 使用
	- 访问doc.html后, 可以直接用这个网页测试后端, 雀食方便
	- 他不是用来编写接口的, 是写完代码测试的(其实也可以先写接口, 但是只能后端闷头写, 然后吊前端)

## 用注解控制swagger文档

- @Api: 放在controller等类上, 说明这是api
	- (tag="员工类")
- @ApiModel: 放类上说明是entity, VO, DTO
	- (description="传递用的数据格式")
- @ApiModelProperty: 放属性上
	- ("密码")
- @ApiOperation: 放方法上: 说明用途和作用
	- (value="登录")