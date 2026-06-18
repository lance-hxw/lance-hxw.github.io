wait后，线程进入waiting
notify随机唤醒一个
notifyAll唤醒全部
唤醒后变成runnable

# wait的队列：Object Monitor Wait Set，注意这是Set
每个java都有一个monitor，存储调用wait的线程