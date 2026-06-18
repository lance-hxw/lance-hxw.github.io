## gateway
三个接口， post， user， original_sound的搜索
- original_sound没看到在哪用的
## service
bizsrv-post-update
在create帖子的时候添加到post这个index中，内容是{id, content}
然后调用 searchapi-add_item
- 调用searchservice的addItem方法
- 然后调用esmodel的addItem方法

id是专门的identifier服务生成的分布式id，是基于mogo的findaAndModify操作实现的
- 生成的是post 的id， 自然也就是es中存的id

# index
理论上定义了id， mid， tid， hashtags， content， topic， unsearchable ，Ct
但是insert过程中只给 了id 和content
id是keyword
topic和content是分析器：english



