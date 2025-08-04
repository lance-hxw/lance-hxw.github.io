# bean
- String 序列化方式,这样需要额外计算,且不方便局部修改
- Hash,存储一个bean,便于直接修改,但是hash到object需要额外管理
# 小list/set,变化不频繁
- 直接String存储,如昨天的排名,上赛季排名
# 大List/set:不存redis
不然就是大Key
- 大key让网络io"阻塞",且无法分割管理
- 这种应该业务上拆分成多个对象,如按天,按某个属性进行分割
- 
