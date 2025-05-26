# Create
```go
// 定义数据类型
type User struct{
	Name string `bson:"name"`
}
user :=User{
	Name: "aaa",
}
...InsertOne(ctx, user)

如果要插入多个
user1 := ...
user2 := ...
// insert many 用 interface
users :=[]interface{user1, user2}
...InsertMany(ctx, users)

```
# Read
需要先定义一个bson的查询格式，然后使用find等操作
```go
查单个
var ret User
filter :=bson.M{"name":"aaa"}
...FindOne(ctx, filter).Decode(&ret)

查多个
filter :=bson.M{
	"age": bson.M{
		"$gt": 25 // 大于25
	}
}
// 查出来判err
result, err = ...Find(ct, filter)
...
// 取出全部内容
var users []User
if err = result.All(ctx, &users); err != nil{
	...
}

```
# Update
update包括查和改两步
```go
// 单个
filter := bson.M{"name": "aaa"}
update := bson.M{"$set": bson.M{"age":26}}
result, err := collection.UpdateOne(ctx, filter, update)
// 多个

```
## upsert
正常更新是不开启upsert的， 需要指定upsert：true
即：
```js
db.collection.updateOne(
	{/* filter */},
	{/* update op*/},
	{ upsert: true}
)
```
开启后，在查不到符合filter的文档时， 使用查询条件和更新操作的内容来insert一个

注意：
- 如果update操作中有inc mul等操作， 不会自动新增相关字段， 此时结果是未定义
- 复杂的upsert场景，应该使用findOneAndUpdate并结合returnDocument，projection等操作
# Delete
```go
// 删一个
filter := bson.M{"name": "aa"}
result, err := collection.DeleteOne(ctx, filter)
...
...删除数量是 result.DeletedCount

// 删多个
filter = bson.M{"age": bson.M{"$gt": 50}}
...DeleteMany(ctx, filter)

```