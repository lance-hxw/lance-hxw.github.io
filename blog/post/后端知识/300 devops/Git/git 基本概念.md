git 的本地有四个区域
- 工作目录（working dir
- 暂存区（stage，index
- 资源库（本地repo
- git仓库（remote repo
其中关系为：
- pull： 从remote到workspace
- checkout：从本地repo到workspace
- add：从workspace到index
- commit：从index到本地repo
- push：从本地repo到remote repo
- fetch/clone: 从remote到本地repo

stash是特殊堆栈
