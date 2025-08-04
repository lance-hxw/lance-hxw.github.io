1. Build, Ship and Run
2. Build once, Run anywhere

- 它是对linux操作系统的虚拟化, 借助了linux的命名空间隔离不同容器, 通过cgroups隔离资源和联合文件系统实现, 在其他系统上, 需要使用虚拟机技术.在windows上, 也可以直接运行在wsl上.
- docker三个核心概念
	- Image
	- Container
	- Repo
## 三个概念
### Image
我们需要将一个app的所有文件和环境打包, 在linux中, 我们说"一切皆文件", 而文件系统本身也是由元数据等若干文件组成的, 只要创建并维护一个文件系统, 我们就能构建整个app运行环境.
当运行一个dockderfile时, 每运行一条, 就将这一条指令对上一层的修改打包成一个新的层(而不是直接在上一层修改), 这样堆叠得到若干只读层, 这些层被联合文件系统构建为一个统一的文件系统view.
- 在一开始时, 一般是从一个基础镜像, 如ubuntu20.04, 获取完整的ubuntu fs view, 包括了系统文件, 库, 工具等
当我们运行一个镜像的实例(就是容器)时, 在镜像顶部再放一个可写层, 而其底层还是只读状态.
- 注意, 不是容器包含镜像, 而是镜像运行时就成为容器, 他之所以叫容器, 是因为他有个可写层
	- image是docderfile或其他方法构建的一个只读模版
	- 容器是一个image运行实例, 他"容"的, 是根据image创建的环境中产生的一切修改
#### 层复用实现: 基于hash
在创建image时, 当一条指令运行后, 会先基于指令和之前的层创建一个新的层(当前指令对之前层的修改), 并hash, 然后基于这个hash去复用和缓存.

这样构建的image可以实现复用:
- 本地复用
	- 构建时, 检查本地缓存中是否有对应层
- 远程复用
	- 上传到hub时, 相同的层不会被上传
	- 下载到本地时, 本地已有的层不会被下载
其核心在于**通过层复用, 一个机器上一个相同的层最多占用一份存储空间**, 无论是本机还是repo
### container
当从一个image运行时, 在image基础上放一个container可写层, 变成容器.
一切程序的运行中改变和后续修改都在这个可写层完成.
## repo/Registy
image集中存储在repo中, 一般, 一个Registy中有多个仓库, 每个仓库中有多个image, 每个image有不同tag
仓库分为public和private
public有dockerhub和一些公司的公开仓库
private是自己一定网络范围内创建的repo.
## 实际操作
1. 下载和安装docker 
2. 打包[[使用docker打包和部署应用]]
3. pull并部署[[docker部署]]
4. 镜像加速: [容器镜像服务(ACR)-阿里云帮助中心 (aliyun.com)](https://help.aliyun.com/zh/acr/)
## docker file
创建一个image必须要写file, 不过也可一个把一个容器打包成image, 就是将container层变成只读的
[Docker从入门到精通——编写 Dockerfile 的最佳实践 - 左扬 - 博客园 (cnblogs.com)](https://www.cnblogs.com/zuoyang/p/16355632.html)

