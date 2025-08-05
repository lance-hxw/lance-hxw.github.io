## 位置
一般位于/etc/nginx/nginx.conf下

## 基本结构
- 全局配置: 适用于整个nginx服务器
- 事件块(events): 控制nginx如何处理连接
- HTTP: 定义http相关配置, 包括服务器和虚拟主机等
	- 服务器块: server: 配置一个具体的虚拟主机
	- 位置块: location: 定义如何处理特定URL路径的请求

### 全局配置: 在文件开头
```conf
user www-data; # 指定Nginx运行的用户和用户组
worker_processes auto; # 设置进程数为cpu核心数
pid /run/nginx.pid; # 指定nginx主进程PID的文件路径
```
### events 块: 如何处理网络连接
```conf
events {
	worker_connections 1024; 每个进程的最大连接数
}
```

### http: server和location
- include: 导入外部配置文件, 如mime.types
- log_format
- access_log: 指定访问日志的文件路径
- sendfile: 开启或禁用此系统调用, 用于高效发送文件
- keepalive_timeout: 定义长连接的超时时间
```nginx
http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	log_format main ...
	access_log /var/log/nginx/access.log main;
	sendfile on;
	keepalive_timeout 65;

	server {
		listen 80; # 监听端口
		server_name example.com; #名字

		root /var/www/html;
		index index.html index.htm;

		location / {
			try_files $uri $uri/ =404;
		}
		location ~* \.(jpg|png)${
			expires 30d;
			access_log off; 禁用静态文件的日志记录
		}
		# 反向代理
		location /api/ {
			proxy_pass http://backend_server; 转发到后端
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto $scheme;
		}
	}
}

```

## server配置
- listen: 监听ip端口
- server_name: 域名
- root: 站点文件根目录
- index: 选择默认加载的首页文件index.html
- error_page: 错误页面路径
### 处理不同请求

#### 1. 静态资源
```nginx
location ~* \.(jpg|jpeg)$ { 
	expires 30d; #缓存30day
	access_log off; #关掉log
}
```
#### 2. 动态请求的反向代理, 用于转发服务, 用于分布式系统和微服务架构
```nginx
location /api/ {
	
}
```
#### 3. 错误页面处理
```nginx
error_page 404 /custom_404.html;
location = /custom_404.html {
    root /var/www/errors;
    internal;
}
```
### location后的路径格式
- 正则表达式: 一般用与特定类型文件
	- ~\* : 表示大小写不敏感的正则表达式匹配
		- ~表示大小写敏感的正则表达式匹配
		- 一般用于忽略文件名大小写, 如~* \\.(jpg|jpeg)
	- \\. ,由于后面是正则表达式, 所以用转义符号表示.
	- (jpg|png), 正则表达式中的分组, |是或
	- $是正则表达式的结束符号
- 前缀匹配(默认)
	- 即 /some/path, 此时所有这个前缀的都会被处理
- 精确匹配(=)
	- 如: location=/some/path/op, 只处理这个请求
- 通配符匹配
	- ^~为: 如果找到前缀匹配就立即停止检查正则表达式, 定义特定路径的处理规则, 避免和正则冲突
### location中可以的操作
#### 1. root&alias: 根目录设置
- root:将请求URI附加到指定根目录 root/path/xxx
- alias: 直接映射到指定目录, 而不是附加 root/xxx
#### 2. index , 索引文件设置
- index: 指定默认索引文件, 如果没有指定文件, 就加载
#### 3. proxy_pass 反向代理
```nginx
location /api/ { 
	proxy_pass http://backend_server; # 转发到 http://backend_server 
	proxy_set_header Host $host; # 保持主机头部信息 
	proxy_set_header X-Real-IP $remote_addr; # 传递客户端的真实IP 
}
```
#### 4. 重定向 return和rewrite
- return : 返回指定状态码或URL, 如return 301 url, 直接重定向
- rewrite: 重写
#### 5. internal: 指定内部访问
- 直接internal; 这个页面只有在服务器返回时才可以访问
#### 6. 缓存控制
- expires: 为静态资源指定缓存时间
- add_header: 向响应中添加http头
#### 7. 限制访问(allow, deny, auth_basic)
## upstream配置:
- 定义一个上游服务器组, 并给服务器定义权重, 权重表示接受请求的比例大小
如:
```nginx
upstream webservers {
	server 127.0.0.1:8080 weight=90;
}
```
## map: 创建变量映射表, 用于在不同请求条件下动态设置变量值
如
```nginx
map $http_upgrade $connection_upgrade {
	default upgrade;
	'' close;
}
```
其中 http_upgrade是nginx变量, 是http请求中的upgrade头, 标志客户端希望的协议, connection_upgrade根据前面那个变量动态赋值
表示: 如果http_upgrade存在且有值, connection_upgrade设置为upgrade, 否则为close
如上这个配置用于ws连接时需要升级http连接支持双向通信
## 常用内置变量
- **`$host`**:  请求的域名
- `$remote_addr`: 请求来源ip
- **`$uri`**：请求的 URI（不带查询参数的部分），例如 `/index.html`。
- **`$args`**：请求中的查询参数，表示 URL 中 `?` 后的部分。
- **`$request_method`**：HTTP 请求方法，如 `GET`、`POST`、`PUT` 等。
- **`$query_string`**：与 `$args` 相同，表示请求中的查询参数。
- **`$request_uri`**：完整的原始请求 URI，包括查询字符串。例如：`/search?q=nginx`。
- **`$document_root`**：当前请求中 `root` 指令设置的值。
- **`$server_name`**：匹配当前请求的 `server_name`。
- **`$server_addr`**：服务器的 IP 地址（注意：在有些情况下，可能会进行 DNS 查询，因此可以显式设置以避免性能开销）。