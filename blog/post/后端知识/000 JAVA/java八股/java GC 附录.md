下面这份速览把 Java 常见 GC 算法里“新生代/老年代的回收方式”和“对象的一生”串起来讲清楚（以 HotSpot 为主，JDK8→JDK21+）：

# 总体概念

- **分代假设**：大多数对象“朝生夕死”，少数会存活很久。于是堆划为**新生代**（Eden + 两个 Survivor 区 S0/S1）和**老年代**。
    
- **两类 GC**
    
    - **Minor/Young GC**：只收新生代；通常是“复制”算法（Eden→Survivor），暂停时间短。
        
    - **Major/Old/Mixed GC**：涉及老年代；不同收集器实现不同。
        
    - **Full GC**：整堆（含元空间）Stop-The-World，最重。
        
- **分配路径**：对象优先在线程本地缓冲 **TLAB**（Eden 内部）分配，TLAB 不够再走共享 Eden。
    
- **晋升（Promotion）**：多次在 Survivor 存活或 Survivor 放不下/大对象等条件下，“晋升”到老年代。
    

# 对象生命周期（典型）

1. **创建**：多数小对象分配到 Eden（通常先进 TLAB）。
    
2. **Minor GC** 触发（Eden 满/分配失败）：
    
    - GC 复制“仍然可达”的对象到空的 Survivor 区（S0 或 S1），**年龄 +1**。
        
    - 满足“晋升条件”的对象进入老年代：
        
        - 达到 **MaxTenuringThreshold**（默认常见值 15，收集器可动态调整）。
            
        - **动态年龄判定**：当某一年龄及其以上对象在 Survivor 的合计占比超阈值（如 TargetSurvivorRatio），就提前晋升。
            
        - Survivor 放不下或对象很大（见下）。
            
3. **长期存活**：进入老年代，等待老年代的回收（Major/Mixed GC）。
    
4. **特殊大对象**：
    
    - 传统收集器可用 **PretenureSizeThreshold** 让“超大对象”**直接进老年代**（G1 忽略此参数）。
        
    - **G1** 把“**Humongous**（巨型）对象”直接放在一串连续 Region（一般 ≥ 50% 的 Region 大小即为 humongous）。
        
5. **死亡回收**：在后续 Young/Major/Mixed/Full GC 中被识别为不可达而回收。
    

---

# 各收集器如何做 Young / Old GC

## Serial / Parallel（含 Parallel Scavenge + Parallel Old）

- **新生代**：**复制**算法，Stop-The-World；Serial（单线程），Parallel（多线程）。
    
- **老年代**：**标记-压缩**（Parallel Old 多线程），STW。
    
- **适用**：吞吐量优先、CPU 核心较少或对简单配置友好。
    
- **调参常见项**：`-XX:MaxTenuringThreshold`、`-XX:TargetSurvivorRatio`、`-XX:PretenureSizeThreshold`、`-XX:+UseParallelGC`。
    

## CMS（Concurrent Mark Sweep，已过时/移除于较新 JDK）

- **新生代**：多数与 ParNew（并行复制）配合。
    
- **老年代**：**并发标记-清除**（非压缩），暂停短，但易**碎片化**；碎片严重或并发失败会触发 **Full GC（压缩）**，停顿长。
    
- **现状**：生产上基本被 G1/ ZGC/ Shenandoah 取代。
    

## G1（Garbage-First，JDK9+ 默认，JDK21 仍广用）

- **堆划分为均匀大小的 Region**（而非固定新/老连续大区）。逻辑上仍有“新生代/老年代”概念，但以**Region 集合**表示。
    
- **Young GC**：选取一批**Young Regions**做复制回收（暂停，复制到 To-Survivor/Old）。
    
- **Mixed GC**：在总体占用逼近目标时（`-XX:InitiatingHeapOccupancyPercent`），**同时回收部分老年代 Region**（优先垃圾多的 Region），以控制停顿目标（`-XX:MaxGCPauseMillis`）。
    
- **大对象（Humongous）**：直接占用一串 Region，单独跟踪与回收。
    
- **Remembered Set** 与 **Card Table**：跨代引用精确跟踪，减少全堆扫描。
    
- **优势**：可预测停顿、自动进行“部分压缩”（复制即整理），碎片压力小。
    
- **调参关注**：目标停顿、Region 大小、IHOP、Mixed 回收强度等。
    

## ZGC（JDK15+ 生产可用，JDK21 有“分代 ZGC”）

- **核心**：**并发、可扩展、极短停顿（毫秒级）**，通过**着色指针/读屏障/转发表**等实现**并发标记与并发重定位**。
    
- **分代 ZGC**（Generational ZGC）：引入代际，进一步减少整体开销（JDK21 起可用）。
    
- **Young/Old**：ZGC 以 Region/分页化管理对象，Young 回收与 Old 回收都尽量**并发完成**，停顿与线程数弱相关。
    
- **适用**：超大堆（几十 GB～TB）且严格低停顿场景。
    
- **特点**：无长时间压缩停顿、几乎常量级暂停。
    

## Shenandoah（Red Hat 主导，JDK11+，JDK17/21 也可）

- **核心**：**并发压缩**（Concurrent Compaction），通过 **Brooks Pointer** 等机制在移动对象时仍并发访问。
    
- **分代模式**：也提供 generational 变体。
    
- **Young/Old**：同样以 Region 方式管理，Young/Old 的回收都尽量并发，STW 极短。
    
- **适用**：低延迟、OpenJDK 生态。
    

---

# 触发条件与失败回退

- **Young GC 触发**：Eden 分配失败、到达阈值。
    
- **Old/Mixed 触发**：老年代/混合 Region 的占用或 IHOP 触发、预测到无法达成停顿目标时提前回收（G1）。
    
- **并发失败/晋升失败**：当回收跟不上分配、或晋升时老年代放不下，会回退到 **Full GC（STW 标记-压缩）** 以“急救”。
    

---

# 常见参数/现象速记

- `-XX:MaxTenuringThreshold=N`：对象在 Survivor 里“熬”到 N 次年龄就晋升（G1 会动态判定；ZGC/Shenandoah 的 generational 模式由实现决定具体细节）。
    
- `-XX:TargetSurvivorRatio`：Survivor 目标占比；配合**动态年龄**影响晋升时机。
    
- `-XX:PretenureSizeThreshold`：**大对象直进老年代**（G1 不用它；G1 用“Humongous”规则）。
    
- **跨代引用**：通过写屏障维护 **Card/Remembered Set**，避免 Young/Old 互扫全堆。
    
- **TLAB/PLAB**：线程/并行复制时的本地缓冲，加速分配与复制。
    

---

# 选型建议（超精简）

- **吞吐量优先**、对停顿不敏感：Parallel GC。
    
- **通用低调优**：G1（默认即可，易维护，停顿可控）。
    
- **超大堆 + 极低停顿**：ZGC 或 Shenandoah（优先 ZGC，社区主线更强）。
    
- **遗留 CMS**：尽量迁移。
    

---

需要我结合你的 JDK 版本、堆大小与延迟目标，给一套更精确的 GC 选型与参数基线吗？