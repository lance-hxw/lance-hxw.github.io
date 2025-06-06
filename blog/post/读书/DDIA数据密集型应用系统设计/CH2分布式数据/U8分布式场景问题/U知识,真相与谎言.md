分布式系统的特点:
- 进程间不能共享内存, 只能消息传递
- 只能通过网络通讯, 但是:
	- 不可靠
	- 且无界的延迟
- 需要处理不可靠时钟的时钟漂移问题
- 需要处理任何可能的进程停顿

分布式系统最大的复杂度来源就是: 不能确信任何事情,即:
- 只能通过网络中得到的回复来进行**推测**
- 只能和其他节点**交换信息**来确定状态
- 如果一个节点没有响应, 无法分析是哪里的问题

于是, 对分布式系统的讨论走向了什么是真相

我们无法去获取完全可靠的系统,但是可以:
- 做出基本假设, 保证这些功能的可靠
- 构建出不完全可靠的系统
- 利用能被证明正确性的算法, 利用不可靠的系统实现整体相对可靠性, 如TCP

这个系统设计过程主要涉及:
- 对底层作什么假设
- 对上层提供什么承诺

