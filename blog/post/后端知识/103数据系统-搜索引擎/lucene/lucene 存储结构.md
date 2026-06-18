es在lucene上构建，lucene主要处理segment等索引文件，es自己维护translog等结构

# 基于segment 的存储

使用定时生成segment的结构， 结合WAL保证持久性

写入是写内存， 所以非常快

## 其他概念
- doc：lucene中一条记录
- field：字段
- term， lucene索引的最小单位， 
	- 如果一个field内容是全文索引， 就分词得到term list， 否则每个字段 作为一个term
-  inverted index， lucene倒排索引， term到doc的映射
- 正排索引：原始数据
- doc values， es中的列存， 用于分析和排序

# Ref.
[Day 7 - Elasticsearch中数据是如何存储的 - 搜索客，搜索人自己的社区](https://elasticsearch.cn/article/6178)