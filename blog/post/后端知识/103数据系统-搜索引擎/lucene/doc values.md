即文档->terms 的列存

即每个field的doci_id-value的列存

对每个字段维护一个文档->值的映射, 可以方便访问一个字段的很多值, 用于排序聚合等场景

如果用不到聚合或者排序的字段, 可以直接关闭, 默认是开启的(text字段不支持)
如果要对文本做聚合或者排序, 用keyword类型

存在一个索引的.dv文件

# Ref.
[【ES 系列4】Doc Values 详解 - 知乎](https://zhuanlan.zhihu.com/p/76224010)
[elasticsearch - 一文带你彻底弄懂ES中的doc_values和fielddata - 犀牛饲养员的技术笔记 - SegmentFault 思否](https://segmentfault.com/a/1190000021668629)