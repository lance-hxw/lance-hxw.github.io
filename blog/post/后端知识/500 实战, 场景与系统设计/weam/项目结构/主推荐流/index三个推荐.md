超过1s是慢查询
# recommend  主推荐流（for you）
有三个方法，
- rec， 
- recommendDegradeLite， 
	- 降级逻辑
- assembleRecPosts
	- 组装帖子

## Rec
tldr：
正常（无降级容错）流程为：
先校验数据
然后初始化数据和状态
接下来是正常pull逻辑， 拿到兴趣， 然后组装ugcrec 的rq， 然后pull， pull到空了就降级
记录请求到的pids， 然后处理打点等
走到defer逻辑， 首先处理降级（降级推荐，不行就apollo默认）
然后按设备id插入特定帖子
然后组装
此时还要决定弹不弹窗啥的

### 参数校验和初始化

### 回复逻辑（defer
- 如果走过degrade， 先调用recommendDegradeLite， 或者从apollo中读取兜底pid
- 从apollo的白名单中看是否要强行插入特定pid到feed第一位
- 将最终pid列表传给assembleRecPosts
- 根据客户端版本决定下发推送导引弹窗
- 将组装好的卡片返回
### 拉取逻辑

- 若请求有降级标记， 将degrade设置为true然后return走降级逻辑
- 否则去miscapi获取用户兴趣标签
- 然后构造ugcrec.RecRe
	- 包括mid， did， 过滤条件，app版本，网络，位置信息，性别，兴趣等
- 调用ugcrecapi.Rec拿到推荐结果
	- 若是空或者报错， 设置degrade true， return走降级逻辑
- 正常返回时，将rec.list中每个itemid取出，保存曝光tag，埋点的roadmap和rcqueuelist

## recommend Degrade Lite
直接调用recsubsituteapi.Index拿到兜底pid列表，如果还失败就报错
在rec的defer中调用时， 如果还是空 ， 会从apollo中配置rec_guarantee_pids读取一些pid

会调用bizsrv-server-recubsititute里的index，不传数量就默认12条，最多30条

他是从redis中取，先pop出一批， 过滤成需要的类型
如果设备池空或者数量不够， 就同步补充， 将日级全量池和历史曝光去重， 合并进去，然后pop

最终返回的数据是：
- zset中按优先级存储的每日候选和设备池
- 从中pop出来，进行包装

是将最近（默认30天）帖子放进一个池子中，然后从中取数据到设备专属zset中，同时，历史曝光过的池子也传进去，然后将全中设置成0，实现去重
## assembleRecPosts
根据pid列表调用postapi.PostGetPostInfoStByPidWithExts拉取帖子详情（视频， 点赞，评论，分享）
逐条将原生protobuf转换成前端需要的卡片结构（AssemblePostDataV2），收集埋点数据（播放量，神评， 热点）
异步调用memberapi.IncMemberStatCnt，给后端打用户刷贴数埋点
返回最终的RecommendBaseInfo,里面的list就是客户端需要渲染的帖子数组

## 相关打点和监控
- 调用推荐， 拿到pid， 拼装卡片后，都有埋addActionLog
- 若推荐结果是空，上报xcmetrics.AddValue("recEmpty", 1)
- 所有外部调用都有错误日志和响应审查

# 整体设计
一个pull结构，客户端每次请求数据都访问rec接口， 后端拉取pid列表后组装为最终帖子

# 涉及service


# 请求参数
除了baseHeader外，
- cold_start: 冷启动场景标记（如刚打开客户端或者长期没拉）
- next_cb 分页游标，callback，前端下次请求带回，用于定位下一页
- offset 
- tab：当前页面标识
- filter: 内容过滤条件， 如all, fresh, video
	- 推荐逻辑中默认为all
- feed_stream_id：feed流id， 去重或者延续同一条流的上下文
- sub_category_on， 子分类推荐， 1开0关
- direction， 翻页的方向，forward是刷新新内容， backward是加载更多
- auto：自动模式标志， 自动加载或播放的开关
- h_addr:客户端上报的地址信息
- c_types: 客户端支持的内容类型列表
- h_idfa, ios广告idfa， 用于广告归因
- exptag，实验标签map
- h_ua, 客户端ua
- h_loc， 客户端经纬度
- risk_filter， 风险过滤等级
- user_ct， 用户累计刷贴
- bundle_name，包名
- audio，音频标记，1， 普通图文视频是0
- posts: 帖子数量上限
- gps_adid，安卓广告id，用于广告归因
- h_lat/h_lng, 高精度经纬度
- unexposed_pids,去重列表， 客户端告知哪些帖子已经曝光
- h_gender h_age
- h_push_id, 推送打开时的帖子id，后端将该帖子插到流首位
- interactive， 是否展示社区互动样式，
- in_pid，强插私信链接的帖子id
- history_length， 历史已经加载的列表长度， 可以用作计数
- buss_name, 业务线名称
- 
# 回复结果
- 视频质量
- 图片质量， 这俩理论是按wifi、4g分的，目前是一样的
- 

# 其他功能

defer最后面有个openpushpop guide的玩意
这个是给用户下发弹窗的， 让用户把系统推送打开
- 涉及缓存最近弹出情况
- 如果已经打开了推送权限， 就不弹

现在的unexposedpids是没用上