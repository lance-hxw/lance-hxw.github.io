条件表达式，用于find和aggregate
如：
```js
db.products.find({
	$expr: {$lt: ["$stock", "$maxStock"]}
})
```