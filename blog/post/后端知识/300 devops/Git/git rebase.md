用于在自己的dev分支上调整commit结构， 不要用于合并
合并用merge

# 可以：在本地dev分支进行各种rebase
- 可以合并，拆分，重排，修改提交新家
- 让分支历史线性化，没有merge这个操作

# ！！！！！已经并到master的commit就不能动

# 用法

## ？（别用）将当前分支上的改动rebase到目标分支上
```bash
// 正常是对master pull ,然后rebase
git pull
gco dev
git rebase master 

// oneline
git rebase master dev

// 直接从远程rebase
git pull --rebase origin master

// 这就相当于
git fetch origin master
gco dev
git rebase origin/master
```
该操作会将feature上对比master的变动提取出来
然后将现在的master作为base，将变动附加在这新的base上，feature还是指向其最新commit
（会创建一一对应的新提交到master上）

但是！

创建新的一一对应commit的时候，会综合master的最新变动，也就说是如果有冲突，那么feature分支每个新的commit都需要处理冲突

这种用法还有一个非常大的缺点：
- rebase之后就不知道从哪checkout出来的了

所以一般不要用rebase

## 处理“有人先push”
如果直接在一个test之类的分支上在本地处理好了，准备push的时候发现有人push了，这样就会分叉
此时可以git pull --rebase
前提是， 你确定这没有任何冲突， 否则就去弄个分支重新处理

## 调整当前分支commit

首先查看需要处理的区间， 可以根据最近N次commit或者以某个base开始
```bash
git log --oneline 

git log --oneline origin/master..HEAD
```
然后使用交互式rebase
```bash
git rebase -i HEAD~5
// 或者以某个分支为base
git fetch orgin
git rebase -i origin/master
```
运行后显示
```js
pick 1xxxx "xxx"
pick 2xxxx "xxx"
pick 3xxxx "xxx"
pick 4xxxx "xxx"
pick 5xxxx "xxx"
```
顺序是从老到新
然后可以修改前面的pick，保存后执行相应操作
- pick：保留该commit
- reword：保留内容， 修改提交信息
- edit：暂停在这个提交， 进行文件内容修改或者拆分提交
- squash：将这个提交和上一个合并，合并后可以编辑二者的共同提交信息
- fixup：合并，但是直接丢弃当前提交信息
- drop：删除
### 例子
1. 调整顺序：直接移动其中的行
2. 合并：使用s或者fixup
3. 修改提交内容：使用edit
	- 执行完后，HEAD指向这个edit的commit
	- 修改文件后，add然后
		- commit --amend：重写commit
		- git rebase --continue， 继续rebase
4. 拆分提交，在edit之后，可以手动拆分
```bash
git reset HEAD^ :将本次提交所有东西放到暂存区
add xxxx
commit：第一个提交
add xxx
commit：第二个提交
git rebase --continue
```

# ref.
[git rebase详解（图解+最简单示例，一次就懂）-CSDN博客](https://blog.csdn.net/weixin_42310154/article/details/119004977)