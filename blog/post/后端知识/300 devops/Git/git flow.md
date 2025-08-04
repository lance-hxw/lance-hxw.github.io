# 一个功能从开发到上线
基本流程是：
- 从master checkout
- 在dev上开发
- merge到test测试
- merge到线上
## 开发dev
```shell
# 切换到master
git checkout master

# pull
git pull origin master

# gco
git checkout -b feature/new-feature
开发
```
## 合并到test测试
```shell
git add .
git commit -m "feat: xxx"
# 推送到远程的dev分支
git push origin feature/new-feature

然后应该发起PR、MR合并到指定分支
。。。
自己操作的话应该
git checkout test
git pull origin test // pull 最新的test分支
# 还需要保证feature分支最新，如果有协作的话
git merge feature/new-feature
。。。 此时如果有冲突就要解决，然后commit
git push origin test //push到远程
```

## merge到线上是同样的

## 命令解析
### pull origin 
git pull origin master是从远程origin仓库的master分支拉最新代码，用于多远程多分支场景
等价于：
- git fetch origin master
- git merge origin/master
一般情况下， 直接git pull是一样的
### gco -b
带-b是创建一个新分支并切换
不带-b是切换到指定分支
# 如何使用PR功能
这个一般是平台功能
你只需要将代码push到远程分支中，然后请求管理员merge就行了
