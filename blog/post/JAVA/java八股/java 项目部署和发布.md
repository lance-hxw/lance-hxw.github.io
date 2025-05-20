# 打包jar包
可以使用maven打包springboot项目，得到一个jar包
参考：[[jar，war包]]
# 部署到http服务器
## spring boot 自带tomcat
此时打包会得到一个jar包， 直接运行即可，配置文件在项目配置文件中写好，相关字段有这些，均为自动加载：
```yml
server:
  # 服务器端口配置
  port: 8081

  # 服务器地址配置
  address: 0.0.0.0

  # 上下文路径配置
  servlet: 
    context-path: /myapp # 默认是空/， 相当于prefix指定app

  # SSL 配置
  ssl:
    enabled: true
    key-store: classpath:keystore.jks
    key-store-password: changeit
    key-password: changeit

  # 连接超时配置
  connection-timeout: 5000ms

  # Tomcat 特定配置
  tomcat:
    max-threads: 200
    max-connections: 10000
    accept-count: 100
    accesslog:
      enabled: true
      pattern: '%h %l %u %t "%r" %s %b %D'
      directory: logs

  # 压缩配置
  compression:
    enabled: true
    mime-types: text/html,text/xml,text/plain,text/css,text/javascript,application/javascript,application/json
    min-response-size: 2KB

  # 错误处理配置
  error:
    path: /error

  # HTTP/2 配置
  http2:
    enabled: true

  # 其他配置
  use-forward-headers: true
  max-http-header-size: 8KB

```
## 手动部署war到tomcat
#TODO 
## 将jar部署到docker
``` 
FROM openjdk:21-slim


# 设置工作目录
WORKDIR /app

# 将构建好的JAR文件复制到镜像中（替换为您的JAR文件名）
COPY *.jar app.jar

# 暴露Spring Boot默认端口
EXPOSE 24181

# 启动应用
ENTRYPOINT ["java", "-jar", "app.jar"]
```