处理虚拟物品背包，配置奖励， 分发， 存储和佩戴

# api

## 用户背包操作
- GetUserBackpackGoods
- AddUserBackpackGood， 添加一个商品
- 使用、佩戴物品 addinuse
- 取消使用、佩戴物品 remove inuse
- 获取所有已经佩戴 getMultiUserWearGoods
## 奖励物品配置管理

- update award conf， 更新
- get award confs， 获取

# 具体功能
## get award confs
获取所有物品的配置的list， 还有一个根据id list获取的， 和这个独立
这个是用来管理页面的
### controller
这里现处理分页，然后调用GetAwardConfs，返回一个List和Total

### logic
直接根据分页信息查db

### db
调用getBackpackColAwardConf（这个就是获取collection），统计total
然后调用find查出分页数据

空查询查所有数据， 将数据存到list中，
排序条件是\[]string{"-\_id"}， 表示按_id降序
- 排序条件是个有序的，所以是数组

### 参数
GetAwardConfsParam:
- offset int64
- limit  int64
GetAwardConfsRes
- list \[]\*mproto.AwardConfSt
- total int64
mproto.AwardConfSt


## update award conf
更新一个conf对象
### controller
直接调用UpdateAwardConf

### logic：先写数据库后删缓存
先拿住awardId
然后调用db
若awardId > 0， 删缓存
- 这个意思是， 如果是update就删缓存
- 如果是insert是不操作的
- 这个缓存是根据id_list去查conf的时候带进来的旁路缓存
	- 这个GetAwardConf是在user_goods那边

### db

若id<=0, 即没有id，查数据库最后一条，手动自增
#TODO 
然后组装数据，
使用upsert更新或者插入
更新参数使用\$set和\$setOnInsert组合
- 只有insert，即不存在该记录时，才设置这个值
- 即，bson中设置Create time为nil， 这样db不处理，如果insert，再传这个值
### 参数
UpdateAwardConfParam
- award_conf：  mproto.AwardConfSt


# 数据模型

## awardConfSt
- ID， \_id
- kindType
	- 1 头像框；2 头像贴纸；3 勋章；6 实物（购物卡）
- name string
- img string，背包图片
- use_img string， 使用图片
- use_img_h int64， 使用图片的h
- use_img_w int64，使用图片的w
- valid_t int 64,有效时长, -1为永久
- ext
- status
- ct
- ut
- 特殊字段，protobuf的优化字段， 实际不存
	- 什么nounkeyedliteral
	- 什么sizecache