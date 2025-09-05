首先是FROM找数据源

然后是JOIN 和ON， 进行联表操作

然后是WHERE
- 朴素情况下， 是server层对engine层获取数据的所有行后进行过滤
- 能利用索引， 就会到engine层下推， 返回更少的行

然后GROUP
然后HAVING

然后是select投影

然后DISTINCT

ORDER BY

LIMIT
