这些参数是在运行时用在java后面指定的， 如：
```bash
java -Xms4g -Xmx4g \
-XX:+UseG1GC \
-XX:MaxGCPauseMillis=200 \
-XX:MetaspaceSize=256m \
-XX:MaxMetaspaceSize=256m \
-XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=/logs/heapdump.hprof \
-jar /app/service.jar
```
# 调优核心参数
## 堆内存参数
### -Xms，和Xmx，初始堆大小和最大堆大小
最佳实践：直接设置二者相等，占用总内存的50-80%
## 新生代和老年代比例，-XX:NewRatio -XX:SurvivorRatio
默认设置老年代比新生代是2:1
Eden相比S区是8:1:1

## GC选择
CMS已经去掉
并行GC，parallelGC， 并行计算任务
G1： 综合， 大内存， 延迟低
ZGC：低延迟，大内存

## metaspace
-XX：MetaSpaceSize，和Max。。
初始和最大
## 其他
-XX：
- +HeapDumpOnOutOfMemoryError：开启溢出dump进行排查
- MaxDirectMemorySIze，限制直接内存
- +UseCompressedOops, 压缩对象指针， 默认启用
# 调优策略
## 确定指标
- 延迟
	- 使用ZGC/G1
- 吞吐量
	- 并行GC
- 内存占用
	- 合理分配heap和metaspace空间，避免频繁GC和OOM
## 工具
- jstat：GC统计
- jmap：堆分析
- jstack： 线程快照

图形工具
- visualVM，实时监控堆， 线程， GC
- MAT， 内存分析
- GC日志， 需要-Xlog:gc*:file=gc.log 分析

# 常见优化场景
## full GC过多
- 检查老年代对象tenuring Threshold
	- full GC来自老年代满
- 扩大老年代大小
## MinorGC时间太长
- 增大新生代
	- 减少S区比例（扩大Eden区
## metaspace OOM
- 检查类加载器是不是泄露（metaspaceGC的管理者）
- 调整metaspacesize
