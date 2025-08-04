Objects是ju里面的工具类
他里面的方法都是java代码实现的，而Object类的方法是本地方法，依赖于jvm
Object的方法都是实例方法，需要用实例调用，Objects里面的都是静态方法

hashCode上
- Object是返回这个对象的hashCode
- Objects是计算参数（Object类）的，并且可以计算多个
- Objects可以安全处理null