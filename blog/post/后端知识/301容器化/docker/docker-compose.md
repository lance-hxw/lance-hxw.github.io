在一个docker 节点上, 用单引擎模式进行多容器应用的部署和管理, 即多个服务构成一个完整的应用.
docker compose的优点在于不需要脚本和大量docker 命令来组织应用, 而是通过一个配置文件直接加载运行.
并且可以通过这个配置文件进行完整的生命周期管理.
## 安装
docker compose需要在docker之外另外安装, 需要时自行搜索
## yml配置文件
一个docker-compose的配置文件是yaml格式的, yaml是json的严格超集, 并且更加人类可读.
docker compose 默认使用文件名docker-compose.yml, 也可以使用-f来指定具体文件
### yaml文件级
一个配置文件包含四个字段:
- version: 必须, 这是这个配置文件的版本
- services: 定义不同的服务
- networks: 配置网络环境, 默认情况下是桥接, 可以用driver指定网络模式
- volumes: 数据卷

一个例子(seafile的docker 部署文件 )
```yml
services:
  db:
    image: ${SEAFILE_DB_IMAGE:-mariadb:10.11}
    container_name: seafile-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${SEAFILE_MYSQL_ROOT_PASSWORD:?Variable is not set or empty}
      - MYSQL_LOG_CONSOLE=true
      - MARIADB_AUTO_UPGRADE=1
    volumes:
      - "${SEAFILE_MYSQL_VOLUMES:-/opt/seafile-mysql/db}:/var/lib/mysql"
    networks:
      - seafile-net

  memcached:
    image: ${SEAFILE_MEMCACHED_IMAGE:-memcached:1.6.18}
    container_name: seafile-memcached
    entrypoint: memcached -m 256
    networks:
      - seafile-net

  seafile:
    image: ${SEAFILE_IMAGE:-seafileltd/seafile-mc:12.0-latest}
    container_name: seafile
    ports:
      - "80:80"
      - ${SEAFILE_SSL_PORT:-}:443
    volumes:
      - ${SEAFILE_VOLUMES:-/opt/seafile-data}:/shared
    environment:
      - DB_HOST=${SEAFILE_MYSQL_DB_HOST:-db}
      - DB_ROOT_PASSWD=${SEAFILE_MYSQL_ROOT_PASSWORD:?Variable is not set or empty}
      - TIME_ZONE=${TIME_ZONE:-Asia/Shanghai}
      - SEAFILE_ADMIN_EMAIL=${SEAFILE_ADMIN_EMAIL:-me@example.com}
      - SEAFILE_ADMIN_PASSWORD=${SEAFILE_ADMIN_PASSWORD:-asecret}
      - SEAFILE_SERVER_HOSTNAME=${SEAFILE_SERVER_HOSTNAME:-example.seafile.com}
      - SEAFILE_SERVER_LETSENCRYPT=${SEAFILE_SERVER_LETSENCRYPT:-false}
      - FORCE_HTTPS_IN_CONF=${SEAFILE_FORCE_HTTPS_IN_CONF:-false}
    depends_on:
      - db
      - memcached
    networks:
      - seafile-net

networks:
  seafile-net:
```
## 服务定义字段
```yaml
nginx_service_name: 服务名
	image: nginx:latest
	build: ./app 如果指定了build, 就会从指定目录或者dockerfilie中build镜像, build和image互斥
	container_name: 指定该容器名字
	command: ["python", "server.py"] 当entrypoint的参数
	environment: 环境变量
		- PORT=100
	volumes: 挂载
		- myvolume:/data
	ports: 端口映射
		- "8000:80"
	networks: 配置需要链接的网络, 可以使用默认网络或者自定义网络
		- my_network
	depends_on: 指定依赖关系, 表示依赖, 单不代表启动顺序
		- db
		- redis
	restart: always 重启策略
	extra_hosts: 添加额外的主机名解析!!!!!!!!!
		- "lance.com: xxx.xx.xx.xx"
	logging: 指定日志驱动
		drvier: "json-file"
		options:
			max-size: "200m"
	healthcheck: 健康检查
		test: ["CMD","curl", "-f","xxx"]
		interval: 20s
		retries:4
	entrypoint:指定启动命令, 直接覆盖entrypoint而不是作为参数
	cap_add/drop: 添加删除容器的linux能力, 可以限制容器权限
		- NET_ADMIN
	user: "100:100" 指定用户和组
	ulimits: 配置ulimit, 如文件描述符数量
		nproc:65
	secrets: 配置docker secrets, 存储敏感数据
		- my_secrets
	deploy: 用于在swarm模式下部署服务的高级选项
		replicas: 4 多副本
		resources: 需要资源
			limits:
				cpus: "0.5"
				memory: "100M"
	labels: 给服务添加标签, 用于后续的筛选和管理
		com.example.description: "myservice"
	

```
## 应用级操作
docker-compose:
- up -d : 启动服务, 后台
- down: 停止服务
- ps 列出所有容器
- logs 查看服务日志
- build
- start 启动
- stop 停止
- restart 服务
## docker-compose杂记
- up和start的区别(down和stop同理, down会清理)
	- up是创建所有东西然后启动
	- start只是启动
