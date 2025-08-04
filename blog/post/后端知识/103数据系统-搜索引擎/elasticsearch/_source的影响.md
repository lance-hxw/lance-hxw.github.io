# 与update的关系
在[[update]]中，需要先取出原始文档，修改，然后再index
此时就需要source
关闭后，update是报错的，需要del+put
# 对index计算速度的影响
影响不大，source部分是压缩存储在额外的文件中的（segment分成很多文件）

# 对内存的影响
source部分存在fdt中，在查询时还是会加载到内存中去
此时如果有访问较少的冷索引，就会将索引挤出去

