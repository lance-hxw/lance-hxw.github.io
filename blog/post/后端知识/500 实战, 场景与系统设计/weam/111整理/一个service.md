# controller
一般是提供一个路由表和一个路由函数
路由函数 为ctrl.controller提供服务, 接受一个http controller 和ctx
- httpcontroller中主要包括 请求路径, 方法, 请求参数, client和resp等
- ctx
ctrl的Post等方法会调用route方法

路由表提供f到p的映射, 其中f是具体请求方法

具体请求方法需要参数:httpcontroller, ctx, param
