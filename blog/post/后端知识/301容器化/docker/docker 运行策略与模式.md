## 运行策略
### 正常前台
默认不加任何参数就是前台运行, 接受stdin, 并将标准输出和标准错误都输出到shell

### detached mode
使用-d, 后台运行, 此时不会输出到终端, 但是可以用id查看日志和进入容器

### interactive mode
使用-i参数, 可以保持stdin打开, 一般和-t一起使用, 分配一个pseudo-TTY伪终端, 便于使用

### -id
此时后台运行, 但是保持stdin打开, 可以通过docker attach重连上容器然后交互

### 一次性任务
使用-l可以只执行一次

## 自动重启策略
自动重启参数--restart, 常见策略参数:
```bash
no: 默认值不重启
on-failure: 非正常退出(非0退出)就重启
always: 退出就重启
unless-stopped: 除非被stop, 否则就重启
```

## 挂载策略
- 绑定挂载: 将目录挂到容器中, 即 -v /host/path:/container/path
- 卷挂载: 即: -v my_volume:/container/path
## 网络模式

### bridge: 默认模式, 每个容器链接到docker的桥接网络, 通过主机端口映射访问
如: -p 8080:80
### host: 主机模式, 容器直接使用主机的网络栈, 没有网络隔离(这个在windows上用不了)
如: --network host
### 无网络, 不给网络,  严格隔离
--network: none

## 命令执行模式

通过docker exec 在运行容器内执行额外命令

