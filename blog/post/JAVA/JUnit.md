JUnit是事实上的单元测试标准框架, 单元测试就是对函数进行测试.
- 对于一个A.java, 编写一个ATest.java类, 分别放入src和test中
	- ATest类中的方法加上@Test注解
	- 使用各种assert断言
- 然后用IDE运行JUnit, 如如果有assert不通过, 就没通过测试用例.
- 单元测试不仅能保证修改的正确性, 还能作为调用的示例
注意:
- 测试代码应该简单, 不能给测试写测试
- 测试代码独立, 不需要特定运行顺序
- 注意边界
## Fixture
test中可能要反复初始化
- 可以写@BeforeEach和@AfterEach来处理资源
有的对象初始化完, 想在多个test中使用, 因为耗时长
- 可以写BeforeAll和AfterAll, 这个只会运行一次, 只能处理static变量.是唯一实例
运行每个@test时, 都会创建一个实例, 此时内部变量都是独立的.test间无法通信.
## 异常测试
## 条件测试
@DisabledOnJre() 之类的还有系统之类的
## 参数化测试
指定数据