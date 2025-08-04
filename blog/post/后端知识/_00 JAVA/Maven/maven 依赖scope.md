依赖传递关系：
嵌套模块使用不同scope的结果

classPath
- compile：javac
	- 将.java编译成class文件
	- 即，编译时需要就得在compile
- runtime：java
	- 运行时需求，如tomcat
- test：mvn test
# compile
- 编译运行都需要
# provided
- compile需要
- 运行时不需要，如servletapi，运行时需要接口
	- 实际运行有tomcat等实现提供
- 或者Lombok，编译工具，不需要运行
# runtime
- 运行需要
- 这种包一般都是反射加载自己，然后动态加载到对应接口上去
# test
mvn test
# system
本地lib
# import
Dependency Management用
