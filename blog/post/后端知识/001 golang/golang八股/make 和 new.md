都是用于给变量分配空间

new 是给string， int， 数组分配的， 给slice等分配，会得到nil的类型，不能使用
make只能给slice， map， chan分配， 一般可以指定cap

new 返回指针
make 返回对象

new是0值化，而没有初始化， 所以如果用于对象， 就会出问题，如map是一个nil
make得到的类型是完成初始化的

这主要是值类型和引用类型的区别
int，bool，struct等都是值类型，不需要初始化
map，slice等是底层对象的引用， 需要初始化
- 比如slice是指向一个底层数组，没有初始化，直接访问读到0值，没有任何含义
- 而int等，指向数据， 直接读出数据就行
