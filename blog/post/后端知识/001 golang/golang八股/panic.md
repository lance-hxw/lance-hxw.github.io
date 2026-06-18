会go自己触发， 或者手动panic抛出

## 恢复

使用recover恢复
即 defer 中 r:=recover()

## 影响

如果一个g发生了panic，且没被捕获

如果是主goroutine， 整个程序崩溃

如果是子goroutine，不会影响其他goroutine