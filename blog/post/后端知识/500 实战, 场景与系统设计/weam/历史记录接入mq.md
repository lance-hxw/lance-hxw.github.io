我先快速扫一遍代码里“历史记录”和“消息队列”的现状，以便给出符合你们现有网关/服务的整合方案。随后会基于现状给出网关→MQ→服务消费的完整设计（主题、消息体、幂等、降级与监控等）。如果发现实现细节不确定的点，我会标注出来。
Ran tool
Ran tool
Ran tool
Ran tool
Ran tool

Ran tool
Read file: /Users/xckj/workspace/weamProj/service/adapter/proto/kafka/proto/topic.go
Read file: /Users/xckj/workspace/weamProj/service/gateway/controllers/user/view_history.go
Read file: /Users/xckj/workspace/weamProj/service/service/bizsrv/controllers/user/view_history.go
Read file: /Users/xckj/workspace/weamProj/service/service/bizsrv/server/user/logic/db.go

Ran tool

我将并行查看现有Kafka封装的writer/reader，以便设计网关产出与服务端消费的实现细节（topic、消息体、回溯/幂等）。随后会给出落地步骤与需要你确认的不确定点。
Read file: /Users/xckj/workspace/weamProj/service/infra/lib/kafka/kafka_writer.go
Read file: /Users/xckj/workspace/weamProj/service/infra/lib/kafka/kafka_reader.go

Ran tool
Read file: /Users/xckj/workspace/weamProj/service/adapter/proto/kafka/proto/proto.go

Read file: /Users/xckj/workspace/weamProj/service/service/postaux/internal/service/auxevent/init.go

Read file: /Users/xckj/workspace/weamProj/service/service/bizsrv/server/attention/event/init.go

Read file: /Users/xckj/workspace/weamProj/service/gateway/controllers/stat/action.go

Ran tool

Read file: /Users/xckj/workspace/weamProj/service/service/bizsrv/server/attention/internal/model/init.go

### 结论先讲
- 在网关把“添加观看历史”改为写入Kafka（key=mid）异步落库，服务侧新增消费者顺序消费并写Mongo，从而完成削峰。
- 保留“清空历史”为同步逻辑，但同时写入一个用户级“清空时间水位线”（Redis），消费端丢弃水位线之前的旧消息，保证清空后的幂等与时序正确。
- DB更新用唯一索引(mid,pid)+$max(view_time、expire_at)实现幂等与乱序容忍。

下面给出最小改造、与现有系统的对接点和需要你确认的关键点。

### 现状锚点
- 网关同步写服务：
```startLine:endLine:weamProj/service/gateway/controllers/user/view_history.go
L68: 	_, err = userapi.New(ctx.TracingCtx).AddUserViewHistory(&proto.AddViewHistoryParam{
L69: 		Mid: &param.Mid,
L70: 		Pid: &param.Pid,
L71: 	})
```
- 服务落库（同步 Upsert）：
```startLine:endLine:weamProj/service/service/bizsrv/server/user/logic/db.go
L912: 	// 使用 mid_pid 作为唯一ID，走唯一索引
L918: 	update := bson.M{
L919: 		"$set": bson.M{
L920: 			"mid":       mid,
L921: 			"pid":       pid,
L922: 			"view_time": viewTime,
L923: 			"expire_at": time.Unix(viewTime, 0).Add(180 * 24 * time.Hour),
L924: 			"deleted":   0,
```
- 网关已有Kafka Writer，可直接复用：
```startLine:endLine:weamProj/service/gateway/controllers/stat/action.go
L752: 	if len(postPlay) > 0 {
L753: 		writer := server.GetKafkaWriter()
L757: 			data := &kafkaproto.PostPlayActionSt{
L758: 				Plays: postPlay,
L759: 				Ts:    time.Now().Unix(),
L761: 			_ = writer.SendMsg(kafkaproto.PostPlayTopic, strconv.FormatInt(h_m, 10), data.Marshal())
```
- 服务已有统一Kafka Reader（分组消费、分区位点管理）可复用。

### 目标设计（结合现有基础设施）
- 新增Topic
  - `adapter/proto/kafka/proto/topic.go`: 增加 `ViewHistoryTopic = "weam_user_view_history_topic"`
- 新增消息体
  - `adapter/proto/kafka/proto/proto.go`: 增加 `ViewHistoryEventSt { Mid int64, Pid int64, Ts int64 }`，沿用已有的 JSON Marshal/Unmarshal 模式。
- 网关改造（产出端）
  - 在`addViewHistory`中，改为向Kafka写消息，key使用`mid`的字符串，保证同一用户有序（Writer已配置HashPartitioner）。
  - 消息体：`{mid, pid, ts=客户端到达网关的当前时间}`。
  - 成功写入即返回200，极端异常时（Writer不可用/队列满）可“降级策略二选一”：
    - A: 回落到老的同步RPC写（保证不丢，但削峰效果打折）
    - B: 丢弃并打点告警（削峰最强，但可能丢数据）
- 服务改造（消费端）
  - 新增`bizsrv/server/user/event`包，初始化Kafka Reader，group建议：`user_view_history_event`。
  - 回调中：解码消息后调用“带时间参数”的写库方法（见下）。
  - 写库改造（最佳实践）：
    - 将现有`AddUserViewHistory(mid,pid,viewTime)`的Mongo更新从`$set`改为
      - `$max: { view_time: ts, expire_at: ts+180d }`
      - `$set: { mid, pid, deleted: 0, ut: now }`
    - 这样在乱序/重复情况下也不会把较新的view_time被旧消息覆盖；TTL也随最大view_time延长。
- 清空语义（关键一致性点）
  - 维持现有“清空历史”为同步DB更新（将deleted置1）。
  - 同时写入Redis水位线：`view_history:clear_ts:{mid} = now`（持久期建议≥180d或无过期）。
  - 消费端落库前先读该mid的`clear_ts`（可做本地LRU缓存1分钟），若`event.ts <= clear_ts`则丢弃该消息，避免“清空后被旧消息复活”。
  - 若你倾向“清空也走Kafka保证强时序”，可以把清空动作也发同一topic（type=clear），消费端按顺序处理；但这会让“清空后立刻查”短时依赖消费延迟，不建议改动现有用户体验，除非业务允许最终一致。
- 读路径保持不变
  - 现有`GetUserViewHistoryList`不改；因为我们在消费端已防止旧数据复活，且唯一索引+排序已匹配分页游标逻辑。
- 监控与SLA
  - 网关：队列满比例、写失败、降级计数、消息大小。
  - 服务：消费速率、topic lag、消费错误、Mongo写入错误。
  - 告警：lag超阈值、连续写失败。
- 容量与扩展
  - 生产端：key=mid保证同用户时序；多分区分摊不同用户。
  - 消费端：同group内可多实例水平扩；每分区单协程处理，避免乱序。
- 回滚与灰度
  - 通过配置开关控制：gateway异步写开关、fallback策略、consumer启停。先灰1%，逐步全量。

### 不确定点（需要你确认）
- 网关降级策略选择：A（回落同步RPC）还是 B（直接丢弃并告警）？
- 是否接受将Mongo更新由`$set`升级为`$max`（提升乱序容忍度）？这会改变内部实现但对外接口不变。
- 清空水位线存储放Redis是否可行？是否需要同时落Mongo做灾备恢复？
- Topic命名与Kafka集群配置（hostports、并发、分区数）是否已具备？

### 最小改动面（文件级）没

- `service/adapter/proto/kafka/proto/topic.go`：新增`ViewHistoryTopic`
- `service/adapter/proto/kafka/proto/proto.go`：新增`ViewHistoryEventSt`
- `service/gateway/controllers/user/view_history.go`：在`addViewHistory`中发Kafka（key=mid），并加降级
- `service/service/bizsrv/server/user/logic/db.go`：将历史写入的Mongo更新由`$set`调整为`$max+$set`
- `service/service/bizsrv/server/user/event/init.go`（新增）：注册Kafka Reader与回调
- `service/service/bizsrv/controllers/user/view_history.go`（清空接口）：清空时写Redis水位线

如果你确认上述关键点，我可以按“最小可用版本”帮你补齐上述代码编辑（保留老路由/接口不变，新增逻辑走配置开关）。

- 做了什么/接下来做什么
  - 我已定位现有“观看历史”的网关与服务实现、Kafka读写封装与使用范式；基于此给出与现有系统契合的削峰方案与改造点。
  - 待你确认降级策略、$max改造与水位线落点后，我可以按上述文件清单提交对应编辑。