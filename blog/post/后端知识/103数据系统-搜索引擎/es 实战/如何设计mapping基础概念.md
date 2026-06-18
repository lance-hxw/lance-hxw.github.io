es 支持动态mapping 和显式mapping
# 显式映射

需要显示定义字段类型， 主要类型有：
- text 用于全文索引， 但不能聚合， 排序
- keyword 用于聚合操作
- date
- numeric
- boolean

# 动态

直接插一个元素进去， 就会自动生成mapping