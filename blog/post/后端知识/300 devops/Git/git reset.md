撤销或者重置当前分支状态
可以修改版本历史记录，操作暂存区和工作目录

- 撤销加入staged的文件
- 撤销工作目录修改
- 通过改变HEAD指针，修改历史分支


# 选项

## --soft
只重置HEAD指针
暂存区和工作区不改变

如：撤销最近提交，但保留更改在暂存区， 可以重新提交
- 即撤销commit， 不撤销add

## --mixed（默认
- 重置head
- 重置staged
- 工作区不变
## -- hard
head， stage， workspace全部重置，丢失一切

# 常见用法

回退最近一次的提交
git reset --hard HEAD~1

移除暂存区更改，不动工作区
git reset 
就是撤销add

回退到指定commit
git reset --hard xxxxhashcode


# 协作开发应该用revert
这个是追加一个反向提交