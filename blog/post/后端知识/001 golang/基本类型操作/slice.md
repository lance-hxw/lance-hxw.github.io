# slice是什么
相当于一个数组的引用, 逻辑上是动态数组
其定义为\[] type, 可以使用切片语法得到一个切片, 不过和python完全不一样, 他是一个对原数组的引用, 不是重新生成新数组(第三个参数不是step, 而是cap, cap与前两个参数冲突会panic)
传递切片就是引用传递了(实际上是值传递, 传了指针值, 但是指针底层的数组是没有copy的)
\[]中写了数字就是数组, 没写就是slice
# 声明

应该用make

```go
slice1 := []int{1, 2,3}

var slice2 []int

var slice3 []int = make([]int, 3)

slice := make([]int, 3)

```

# 操作

## 截取
s := s\[0:2]
同理,\[:], \[:3], \[3:]
slice赋值的时候, 复制了指针值,底层数组是一个, 所以在slice上修改, 可能会影响别的slice/数组的值
### 如何深拷贝

copy(s2, s)
将s拷贝到s2中, 结果一样, 但是底层不是一个

## 追加

append(slice \[]type, elems ... type)



## 展开切片
用...展开
可以将一个slice展开成多个独立的参数, 如append方法
其定义为:
```go
append(slice []type, elems ... type)
所以需要将一个slice用...展开然后append
```

### ...还可以
- 表示不定数量的一个类型的参数
- 数组的字面量, 可以表示, 根据字面值的数量指定长度
