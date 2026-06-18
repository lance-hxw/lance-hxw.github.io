有些api里基本给api对象实现了new和do后没有写具体方法
而是在包内写了一些普通函数去调用api的do
这可能是因为直接使用了new apiclient，可以方便复用
这样用起来就类似静态方法了，但是底层还是用apiclient

- 这个项目的跨度比较长，大致有三种实现风格
	- 最早的版本是包内函数的形式
	- 后面两种是写成api成员的
## account

- getAccountByAid: 用aid获取 账号信息Account
- 获取批量账号信息map
- 根据ids获取批量登录历史map
- 根据ids获取状态
- 有个好像是账户注销
## activity， 这个最新，和weam项目相关性最大
- GetBannerListData, 返回mproto.OpBannerSt对象的list
- ht_game 相关的接口， 什么ranke啥的
- native的什么rank啥的
	- 这里面是用户参与活动post之类的接口，有rank，奖励什么的
