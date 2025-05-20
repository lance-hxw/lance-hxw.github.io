数据库连接需要线程复用
有一个标准接口: javax.sql.DataSource, 是java标准库的中一部分, 具体实现有:
- HikariCP: springboot默认的, 使用广泛h
- Druid: 好像是阿里的
- C3P0
- BoneCP
使用dataSource和使用单个的connection不同, 此时不需要提供具体的(URL, user,  password), 逻辑变成了申请一个线程, 这些三元组配置是在线程创建时需要的, 而这些都在配置文件中弄好了.只需要用一定的规则决定如何装配成bean

## DataSource的生命周期(SpringBoot从yml中加载)
- 在yml中配置spring.datasource // 默认为使用HikariCP作为连接池实现
- 在Springboot启动时, 会自动检测spring.datasource, 生成一个DataSource实例
	- DataSourceAutoConfiguration会自动生成一个DataSource Bean
	- 这个DataSourceAutoConfiguration类带有条件装配注解@ConditionalOnMissingBean, 也就是说你没有手动定义的时候
## 手动组装DataSource 的Bean
如果你有特殊需求, 或者需要多个DataSource, 可以这样:
- 这里用到了一个类型的Bean多个实例如何自定义填充的知识
	- @Primary定义默认填充类, 也就是这里的默认DataSource
	- @Bean(name="pgDataSource"), 定义别名
	- @ConfigurationProperties(prefix="spring.datasource.postgres") 从yml中加载properties
	- Qualifier("pgDataSource"), 使用别名指定注入的bean实例
### 如果你用JDBC的话可以这样用, 这也体现了, 其他ORM框架实现诸如"多数据库"等需求有显然的解决方案.
```java
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource; 

@Configuration
public class DataSourceConfig {

    @Primary  // 标记为默认数据源
    @Bean(name = "db1DataSource")
    @ConfigurationProperties(prefix = "spring.datasource.db1")
    public DataSource dataSource1() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "db2DataSource")
    @ConfigurationProperties(prefix = "spring.datasource.db2")
    public DataSource dataSource2() {
        return DataSourceBuilder.create().build();
    }
}

```
### 如果你需要在MyBatis中实现这个功能, 是这样
只需要为所有mapper对象指定sqlSessionFactoryRef就行
```java
import javax.sql.DataSource;
// 关键在于注解指定mapper
@Configuration
@MapperScan(basePackages = "com.example.mapper.db1", sqlSessionFactoryRef = "db1SqlSessionFactory")
@MapperScan(basePackages = "com.example.mapper.db2", sqlSessionFactoryRef = "db2SqlSessionFactory")
public class DataSourceConfig {

    @Primary
    @Bean(name = "db1DataSource")
    @ConfigurationProperties(prefix = "spring.datasource.db1")
    public DataSource dataSource1() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "db2DataSource")
    @ConfigurationProperties(prefix = "spring.datasource.db2")
    public DataSource dataSource2() {
        return DataSourceBuilder.create().build();
    }

    @Primary
    @Bean(name = "db1SqlSessionFactory")
    public SqlSessionFactory sqlSessionFactory1(@Qualifier("db1DataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        return sessionFactory.getObject();
    }

    @Bean(name = "db2SqlSessionFactory")
    public SqlSessionFactory sqlSessionFactory2(@Qualifier("db2DataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        return sessionFactory.getObject();
    }
}

```
