error是一个内建的接口类型
其原型为:
```go
type error interface{
	Error() string
}
```
即,只有一个方法, 导出
没有形参,返回一个string
## 使用error
```go
import "errors"

func func1() error {
	return errors.New("wrong")
}

...
err = func1()
fmt.Println(err)
...
```

## 判断

可以先定义好err , 然后用errors的is或者as来判断和获取具体错误类型