关键在于状态切换和不同状态不同行为, 将不同行为放到不同状态中去, 根据状态切换不同方法, 而不是写if嘎嘎判断嘎嘎执行
而是
```java
private State state=new newState();// 初始状态
public String chat(String input){
	if (...){// 切换状态
		state=new AState();
		return state.init();
	}else if(...){
		state=new BState();
		return state.init();
	}

	//按状态执行
	return state.action(input);
	
}

```
