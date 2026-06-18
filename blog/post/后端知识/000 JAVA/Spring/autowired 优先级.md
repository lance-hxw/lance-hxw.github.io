
首先是按类型找bean
如果只有一个， 直接注入

如果有多个实例
- 按Qualifier，明确指定一个名字
- 没有Qualifier指定，尝试按名字匹配一个
- 可以用@Primary提升bean优先级
- 上述都没有？报错

如果直接没找到，可以设置required = false，不报错

