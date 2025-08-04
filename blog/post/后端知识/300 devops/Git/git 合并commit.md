# 先将版本库和暂存区回退， 保留工作区改动， 然后commit

不能这么做，太乱来了
# git rebase
[[git rebase]]

# merge --squash
他是将目标分支上的所有更改a一次性add到staged，等待commit

普通merge是自动commit的 除非出现冲突