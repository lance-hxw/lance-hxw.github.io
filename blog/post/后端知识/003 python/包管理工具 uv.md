uv行为非常接近python自己的venv

其逻辑是在一个项目下维护一个环境, 即在一个项目的路径下执行uv venv -n xxx,
就可以在当前目录创建一个xxx文件, 然后使用source xxx/bin/activate 激活, 使用deactivate退出
- 如果不指定名字, 就是.venv

在pip前加一个uv就可以进行各种pip操作
- 由于是rust写的, 所以速度快达成了质变
- 有依赖解析而不是直接报错

uv是当前python包管理的最佳实践

