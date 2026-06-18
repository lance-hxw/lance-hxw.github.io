## 使用DDD设计订单模块

不应该去想有什么表，可以写crud

而是：
- 订单应该有哪些规则
- 订单何时可取消
- 支付还能不能改地址
- 计算金额
- 。。。

于是需要编写：
- Order.submit
- Order.cancel
- Order.addItem
- ...

于是订单这个聚合有
- 实体Order
- OrderItem是订单对象
- Money是值对象
- 规则：未支付可取消等等

