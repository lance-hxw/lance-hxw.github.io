是一个指针， 始终指向当前工作目录下的最新快照
即当前分支的最新提交
即标识当前所在版本

gco可以用来切换head位置
# 常见状态

## 指向分支
大部分情况下， 指向某个分支， 如master， main， dev

如HEAD指向main， main指向某个commit， 此时HEAD也就在这个commit上

## 分离 Detached HEAD

如果head直接指向某个提交，而不是分支， 就称为分离头
比如直接gco到某个具体commit上
此时进行新的提交会在这个commit上进行，不在任何分支上

# HEAD^
表示当前分支最新提交的第一个父提交（也就是前一个)