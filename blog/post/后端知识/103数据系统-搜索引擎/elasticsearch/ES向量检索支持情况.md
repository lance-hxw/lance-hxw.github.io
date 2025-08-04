# 版本兼容性
## v7.*
支持KNN，但是速度不可用
可以通过一些插件，如阿里云的向量插件，来支持近似KNN如HNSW算法
- 阿里云的插件对于部分版本不支持
## v8.*
原生支持ANN

# HNSW算法开销
HNSW是一个基于多层图结构的近似算法，其运行时需要将整个图结构存在内存中
## 空间开销
其图结构估算公式为$vec\_nums \times HNSW.m \times 4$ ，单位是Byte，m默认16，一般来说图结构空间占用是很低的
如对于384维度向量，其向量本身占用存储1.5MB/k条，而对应的图结构只需要约64KB，总计约1.6MB/k条
## 计算开销
一般在10ms量级
# 性能优化

## 降低空间开销：\_source
通过将mapping中_source的enable设置为false或者单独excludes向量字段，拒绝让es将原始向量作为文本再存储一次，可以大幅缩减空间占用
- 大幅减少索引大小(2/3)
- 搜索期间减少返回数据量
- 显著提升knn搜索速度
副作用：
- reindex，update操作通常需要该字段，如果排除可能出现意外 [[_source的影响]]

#TODO 
# ref.
[如何使用向量检索插件aliyun-knn_检索分析服务 Elasticsearch版(ES)-阿里云帮助中心](https://help.aliyun.com/zh/es/user-guide/use-the-aliyun-knn-plug-in?scm=20140722.S_help%40%40%E6%96%87%E6%A1%A3%40%40145062._.ID_help%40%40%E6%96%87%E6%A1%A3%40%40145062-RL_%E5%90%91%E9%87%8F-LOC_doc%7EUND%7Eab-OR_ser-PAR1_212a5d4017495317046044552d9676-V_4-RE_new5-P0_0-P1_0&spm=a2c4g.11174283.help-search.i19)
[[1603.09320] Efficient and robust approximate nearest neighbor search using Hierarchical Navigable Small World graphs](https://arxiv.org/abs/1603.09320)
[阿里云Elasticsearch向量引擎使用指南_检索分析服务 Elasticsearch版(ES)-阿里云帮助中心](https://help.aliyun.com/zh/es/user-guide/alibaba-cloud-elasticsearch-vector-engine-usage-guide)
