volume是docker提供的一种持久化数据存储方式

## 在使用docker volume时发生了什么

- docker volume create \<volume-name\>: 在主机系统上分配一个位置, 存储这个卷的数据
- docker run -v \<volume-name>:/path/mnt-dir: 将主机上这个卷中的数据全部挂到容器内
- docker volume rm \<volume-name\>: 删除这个卷的数据
## volume的存储位置
默认在本地, 其中:
- linux: 一般在/var/lib/docker/volumes
- windows: 一般在docker目录下的volumes中
可以通过: docker volume查看(和操控)卷, 提供如下参数:
```bash
create
inspect: display detailed info. on one or more volumes
ls: list
prune: remove unused local volumes, seems dangerous
rm: reomve one or more
```