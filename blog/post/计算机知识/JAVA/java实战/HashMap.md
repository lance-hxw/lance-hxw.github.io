从源码看简易HashMap
## Node部分
原型是Node\<K,V>,实现Map的Entry接口
成员有：
- final int hash
- final K key
- V value
- Node next
### hashcode计算
用j.u.Objects工具类的hashCode方法，并且hash key和value，
然后
```java
hashCode = Objects.hashCode(key) ^ Objects.hashCode(value);
```
- 这样可以组合两个hashCode
	- 并且不容易hash冲突（相比加法这种a+b=b+a的，在常见值域内容易冲突
## 数组上
### 索引计算
index = (n-1)&hash， 位运算效率比取余好，所以不用abs(hash)%n
- 但这样，容量要是2次幂，这样（n-1）才是全1的
- 不过不用处理hashCode的正负了
- 注意hash函数要保证均匀，这样低位上也是均匀的
## put
如果找到就加
否则增加新节点
每次都要判断扩容与否

