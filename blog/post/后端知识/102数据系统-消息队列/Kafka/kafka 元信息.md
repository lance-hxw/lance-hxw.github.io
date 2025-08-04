ISR等元信息一般是作为元信息存储的, 存在zk中或者用kraft协调

一般是leader去检测, 然后更新ISR, 集群中有一个broker充当controller, 在发生宕机的时候, 他去查zk来获取元信息

说是这样说, 实际实现上相当于ISR会存在每个broker上

