## spring的生命周期大致如下

1.需找所有的bean根据bean定义的信息来实例化bean，默认bean都是单例

  

2、使用依赖注入，spring按bean定义信息配置bean的所有属性

  

3、若bean实现了BeanNameAware接口，工厂调用Bean的setBeanName（）方法传递bean的ID

  

4、若bean实现了BeanFactoryAware接口，工厂调用setBeanFactory（） 方法传入工厂自身。

  

5、若bean实现了ApplicationContextAware()接口，setApplicationContext()方法会被调用

  

6、若bean实现了InitializingBean，则afterPropertiesSet被调用

  

7、若bean指定了init-method="init"方法，它将被调用。

  

8、若BeanPostProcessor和bean关联,则它们的postProcessBeforeInitialization()方法被调用

  

9、若有BeanPostProcessor和bean关联，则它们的postProcessAfterInitialization()方法被调用

  

注意：通过已上操作,此时的Bean就可以被应用的系统使用，并将保留在BeanFactory工厂中直到不再需要为止.但我们也可以通过10或者11进行销毁

  

10、若bean实现了DisposableBean接口,distroy()方法被调用

  

11、如果指定了destroy-method="close"定制的销毁方法，就调用这个方法

spring在创建bean的时候，首先会根据bean的定义以及一些信息配置来实例化bean，然后bean若实现了前置处理器或者后置处理器的接口后，就会实现他们对应的方法，比如若bean实现了ApplicationContextAware()接口，setApplicationContext()方法会被调用，另外的具体的实现方法记不太清除了，反正就是一些实现了就执行，实现了就执行这样的顺序一次判断，最后就是bean如果实现了销毁的接口，就会将bean销毁，如果没有实现那就一直保留。