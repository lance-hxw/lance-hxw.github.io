当在bash中输入一个命令，就会fork一个新的进程，调用execve执行命令

# fork
父子进程有独立的地址空间，fork会独立申请资源，会返回两次，在父进程返回子进程pid
重量级调用，完整的副本
# vfork
父进程阻塞，子进程使用相同的进程地址空间，并复制所有资源
# clone
所有资源都是相同的一份
如pthread_create
有些不会克隆，有个标记控制。