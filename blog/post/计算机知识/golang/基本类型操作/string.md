## 判断空值 
```go
不要:
if s==""{
}

应该:
if len(s) == 0 {
	...
}
```

## 去掉前后子串
```go
if strings.HasPrefix(s1, s2){
	s3 = s1[len(s2):]// slice
}
```

## 切片slice
```go
var s []string 空string数组
s := make([]string, 0, 10)

// 判断空?
if slice != nil && len(slice) > 0 {

}
// copy
var b2 []string
copy(b2, b1)// from

// append

var a,b []int
b = append(b, a...)
```

## Trimspace
 去除空白符