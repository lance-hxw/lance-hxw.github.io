
# Object monitor lock
每个java对象天生自带一个monitor可以当做锁
当线程进入一个synchronized(obj)代码块时， 必须要先获取obj的对象锁

- 这个锁和obj绑定
- 一个类的不同实例的锁是独立的
- 两个线程对不同实例加锁不干扰

类锁也是类似的， 只不过是class对象的monitor


其原理是， 在发现是重量级锁时， 去尝试修改monitor的owner（CAS）不成功就加到cxq队列中


# Synchronized 和object.wait/notify

object等待唤醒必须是owner进行， 所以必须在synchronized代码块中，在当前占用锁的情况下进行

synchronized进入退出影响的是entrylist/cxq中的线程， 是fifo的

object影响的是waitset， 也就是说， wait的时候并没有直接去等待锁的队列中， 而是进入的等待集合， 然后调用notify的时候， 会从该对象的waitset中唤醒一个或多个， 放到fifo队列中去

synchronized退出的时候， 会释放锁， 把monitor的owner设置成null， 并清空记数器
