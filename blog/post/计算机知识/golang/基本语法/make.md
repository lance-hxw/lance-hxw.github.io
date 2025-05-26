是一个内建函数，用于创建和初始化
- slice
- map
- chan
语法形式为：
```go
make(type, size[, capacity])
```
其中， type是类型三选一
size对slice和chan是初始长度
对map是容量hint（可选）


capacity只对slice 和chan有效，表示最大长度, 是直接开辟好的
- 如果满了, 会自动开辟, 开辟大小是翻倍(超过256后变成1.25倍)
make是标准使用形式