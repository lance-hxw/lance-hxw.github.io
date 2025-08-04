mybatis是一种半自动ORM框架, 他需要手写sql, 但是会自动将ResultSet映射到javaBean, 或者自动填充bean
## 在maven中安装
只需要添加org.mybatis
```xml
<dependency>
	<groupId>org.mybatis</groupId> 
	<artifactId>mybatis</artifactId> 
	<version>x.x.x</version> 
</dependency>
```
## 在Spring中使用
```java
@Configuration
@ComponentScan
@EnableTransactionManagement // 支持声明式事务
@PropertySource("jdbc.properties")
public class AppConfig {
	@Bean
	SqlSessionFactoryBean createSqlSessionFactoryBean(@Autowird DataSource dataSource)
}
```
- 首先在配置文件中写写上jdbc.properties字段, 其中有个dataSource属性, 包括driver, (url,用户名,口令), 然后他会自动填充到mybatis中



## PageHelper插件
会在page查询查看总共有多少数据
### startPage
- 调用后, 创建一个Page对象, 包括分页的配置信息, 然后将这个分页存到threadlocal中, 具体是通过PageInterceptor实现, 
- 这个拦截器会拦截MyBatis的SQL执行过程, 然后按照当前分页信息, 动态修改SQL
- 在拦截器工作一次后, 这个Page对象就会被从ThreadLocal中清理
### page对象
page实现了List类对象, 此外还有一些特殊接口:
除了list自带的: add(), get(ind), size()外
分页信息的获取:
- getPageNum(), getPageSize()
- getTotal(), 结果总数
- getPages(), 总页数
- 起始结束行号, 排序字段等等..
分页结果:
- hasPreviousPage(), 是否有上一页
- hasNextPage(), 是否有下一页
- isFirstPage(), 是否是第一页, isLastPage(), 是否是最后一页
- 
