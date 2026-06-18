# 成员
函数
- TransVideos与TransVideosWithExts：返回视频对象0001
- slotCalc：根据name和did进行md5，取末尾进行分slot（稳定hash）
- getTransVideosOptionsByExts: 实际生成这个选项信息
	- 默认gcp， slot -1
	- 4个步骤后得到最终RandId（不断覆盖前面的，最后的优先级最高）
	- 1：根据did ab下发（did是用于做ab的
	- 2：有province，并且配置了cdn映射，就根据这个指定
	- 3：ios默认gcp，除非前面之前指定了did用于ab测
	- 4：白名单中有特定did，走白名单(apollo)
	- 这些步骤的指定cdn， 都是设置options中的RandID来指定的
		- 0-49 zen
		- 50-99：gcp
		- 100-149：aws
结构体
- transVideoOptionSt
	- 一个RandIB随机决定cdn
	- did
	- 视频slot
常量
- province - cdnId的映射表
- 
