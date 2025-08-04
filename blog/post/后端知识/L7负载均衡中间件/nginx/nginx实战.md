优点:
- 访问速度提高(通过缓存机制, 有的资源不需要去后端服务中获取)
- 负载均衡, 定义upstream 服务器群, 设置权重进行负载均衡
- 服务器安全: 避免暴露真实服务地址, 攻击者只能攻击nginx服务器, 服务只要部署在内网就行
## 反向代理
如, 前端请求地址为http://localhost/api/employee/login
后端服务地址为http://localhost:8080/admin/employee/login
这是前端走了nginx, 被反向代理将/api/代理到/admin/下了
### 场景1: nginx部署在win-docker中, 后端服务地址为宿主机8080(tomcat), 前端访问端口为5080
```nginx
    server {
        listen 5080;
        server_name localhost;

        location / {
            root /home/nginx/html/sky;
            index index.html;
        }
        error_page 500 502 503 504 /50x.html;
        location /50x.html {
            root html;
        }

        location /user/ {
            proxy_pass http://host.docker.internal:8080/user/;
        }

        location /api/ {
            # proxy_pass http://localhost:8080/admin/;
            proxy_pass http://host.docker.internal:8080/admin/;
        }

        location /ws/ {
            proxy_pass   http://host.docker.internal:8080/ws/;
            proxy_http_version 1.1;
            proxy_read_timeout 3600s;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "$connection_upgrade";
        }
    }
```

## 负载均衡
```nginx
upstream webservers{
	server 127.0.0.1:8080 weight=90 ;
    server 127.0.0.1:8088 weight=10 ;
}
server{
	listen 80;
	location /api/ {
		proxy_pass http://webservers/admin/; #按权重分配负载
	}
}
```
其中weight是负载均衡策略, 如果不写, 就是轮询, 还有:
- ip_hash: ip分桶, 同ip同服务器, 似乎可以方便一些逻辑
- least_conn: 最少连接, 给连接数少的后端
- url_hash: url分桶, 同url同服务器, 似乎可以提升缓存效率
- fair: 根据响应时间??