# go.mod
go的官方模块化支持，1.11后开始，与GOPATH解耦
核心文件是
- go.mod
- go.sum：校验和文件，记录每个依赖模块和其依赖的校验和

```go.mod
module example/xxx

require (
	xxx v1.2.1
	xyy v0.7.1
)
```

## go mod 依赖解析和获取
- proxy： 默认使用https://proxy.golang.org,可以自定义GOPROXY环境变量
- 版本选择算法：基于SemVer， 选取最高兼容版本，如果是伪版本， 按照时间戳排序
	- 会去repo的“tag”中匹配SemVer， 找不到就伪版本

## 常用命令
- go mod init \<module-path>, 在项目目录生成go.mod
- go mod tidy : 增删依赖，清除，确保gomod和gosum最小且完整
- go mod download：下载所有在go mod中声明的依赖，下载到本地缓存
	- 也就是GOPATH/pkg/mod
- go mod verify: 校验本地模块缓存和gosum的记录

## 添加依赖
- 可以直接将repo路径写在mod文件中的require后面
- 使用go get github.com/xxx/xxx@v1.1.1
	- 最新：go get github.com/xxx/xxx@latest

## 检查版本号
go list -m -versions github.com/xxx/xxx

## 没有版本号的依赖
伪版本（go会自动转伪版本）
go get xxxxx@master
require xxxx v0.0.0-\<yyyymmddhhmmss>-\<commit-hash>


# vendor是什么
在gomod出现前，很多项目将第三方依赖直接放在vendor目录中，保证不依赖外部网络， 没有版本问题

## 与gomod结合
go mod vendor：运行后， 将所有依赖按版本拷贝到vendor中，并在gomod中加一个+build约定

构建优先级：
- 当存在vendor目录，且使用默认模块模式，go111modeon，gobuild/test都优先使用vendor
- 如果想忽略vendor， 使用-mod=readonly或者-mod=mod
	- 反之，需要设定-mod = vendor
