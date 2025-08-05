# char
## char转数字
使用包装类的Character.getNumbericValue(‘2’)
使用减法：int i = '2'-'0'

# String
String类型是final的，拼接等操作有大量的资源浪费（中间对象）
所以有stringbuffer和stringbuilder，二者差不多，builder去掉了buffer线程安全的部分，即少量数据用string，多线程用buffer，其他builder
## string 和char array 体操
```java
char[] chars = str.toCharArray();
Arrays.sort(chars);
return new String(chars);
```
## string builder
底层就是一个动态字符数组, 不带线程安全机制
# 数组和Arrays
数组，即\[]，可以创建基本类型数组和对象数组，数组本身也是对象，有length属性，并在堆内存中分配，可以调用getClass方法
```java体操
new int[]{1,2,3} // [1,2,3]
new int[1] // [0]，数组总是会默认初始化
```
有一个标准库中的实用工具类，提供了一系列操作数组的静态方法
java.util.Arrays
主要方法有：
- sort(array,fromIndex,toIndex,comparator)
- binarySearch(array,key)
- fill(array,fromIndex,toIndex,value)
- equals(array1,array2), deepEquals(obj1\[],obj2\[])
- copyOf(array,newLength)
	- copyRange(array,from,to)
- asList
	- 可以用于List<>的构造函数参数
- stream
- toString
- deepToString
- hashCode(array)
- deephashcode
## 接受一个数组并原地操作的函数：
```java
void func(String[] args){
	args[1] = 0;
}
```
# List
```java 体操
return new ArrayList<>(Arrays.asList(1,2,3,3));
return new ArrayList<>(Collection);
return new ArrayList<>(20);
return new ArrayList<>(); // 默认容量10
```
## ArrayList
默认容量10， 但是在第一次添加时才将底层数组大小变成10，此前为空
当元素数量超过当前容量时扩容，一般变成1.5倍当前大小

## 强制转换
合法强转没有问题
如果不兼容， 会报错ClassCastEx。。
可以用instanceof检查是否是某个类型实例。保证合法

## bitset
可变长， 相比boolean更灵活
支持按位操作
使用long\[]，存储
体操：
```java
BitSet bitSet = new BitSet(124);
bitSet.set(0); // set 1
bitSet.clear(5); // set 0
```

