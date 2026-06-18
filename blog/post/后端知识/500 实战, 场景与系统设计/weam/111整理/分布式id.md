# 请求响应
请求参数, id type
返回 id int64

主要方法 : 只有一个gen
# gen

首先根据type判断合法性, 一个rule的map找type的存在性, type还有key和maxstep两个参数
然后获取key, inc, upper, lower, 其中inc由upper lower根据随即得到, 为实际增长数量
- key用于加密(按位异或)
将type和inc给GenIdMongo, 获取一个v作为candi id
现将v用key加密
最终id的分布为:
高位40位: v的高位(去掉最高8位)
中间8位: type
低位16位: v的低16位
相当于将v最高8位去掉,然后中间插一个type

# mongo db 生成v
每个type一个collection , 每个collection只有一个元素, 然后在这个元素上原子增长inc并返回

