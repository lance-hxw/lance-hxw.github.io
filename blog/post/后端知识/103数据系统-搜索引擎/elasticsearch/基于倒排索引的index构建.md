# 编写mapping
- 哪些字段应该支持全文检索：text
- 哪些字段应该精确匹配：keyword
- 为text指定合适的analyzer，如ik，standard等等
# 写数据
通过bulk api或者单文档索引api将json写入index
写入时es对text字段进行analysis
# 查询
使用match query，bool query，filter， 分页，排序等
可以设置相关性（得分），全中，自定义评分等