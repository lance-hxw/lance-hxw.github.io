在某个分支上开发，临时需要换分支，又不想提交的情况下，需要stash

# git stash
保存当前分支的修改， 提交到堆栈中临时保存

可以添加一些备注信息
# git stash save “msg”
## stash untracked

有的修改没有add， 此时需要使用参数-u 或者--include-untracked
## stash ignore？

使用-a会操作所有文件
包括untracked和被ignore的文件

# git statsh list
查看暂存列表

# git stash pop \[-index] \[stash_id]

git stash pop
git 默认将暂存区的代码全部恢复到工作区

可以指定恢复最新的
git stash pop --index

恢复指定的id的代码， id可以用list获取
git stash pop stash@{id}

# 注意：pop后本地进度就没了
# 注意：pop后暂存区的代码也没了

# git stash apply \[-index] \[stash_id]

和pop类似， 但是不会直接从暂存区中删掉

# git stash drop \[stash_id]

删除一个暂存的， 如果不指定id， 删最新的

# git stash clear
清理所有暂存进度

# git stash show
查看最新stash 和当前目录的差异







