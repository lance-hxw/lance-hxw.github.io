用time.sleep和select +time.NewTicker
都可以实现定时任务， 但是time.sleep的方式， 如果相关逻辑执行慢， 会影响每次定时的准确性， 使用ticker的方式， 任务执行的快慢不影响时刻准确性。