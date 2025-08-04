这是 Spring MVC提供的一个拦截器接口, 他是面向http请求的
主要定义了三个方法: 
- preHandle
	- 在请求到达前执行
		- 身份验证, 权限检查, 记录日志
		- 如果返回了个false, 直接被拦截掉
- postHandle
	- 在controller运行后, 视图渲染前
	- 修改view的结果
		- 动态修改内容
		- 记录业务执行信息
- afterCompletion
	- 请求完成后
		- 清理资源, 日志, 处理异常等
## 拦截器如何生效:
### 1. 实现拦截器
首先你需要自己实现拦截器, 可以有多个
### 2. 实现WebMvcConfigurer
这里需要用.addInterceptor(), 将拦截器注册进mvc服务
### 3. Spring MVC 维护 拦截器链
每个请求来时, 按顺序执行拦截器
如果有一步preHandle返回false, 后续拦截器和服务都不运行
## GPT QA
## 1. 实现了拦截器就会自动扫描添加到拦截器链中?
- 不是, 需要在WebMvcConfigurer的实现中手动添加: 
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Autowired
    private FirstInterceptor firstInterceptor;
    @Autowired
    private SecondInterceptor secondInterceptor;
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 将拦截器添加到拦截器链，并配置拦截路径
        registry.addInterceptor(firstInterceptor)
                .addPathPatterns("/api/**") // 仅拦截 /api/** 的请求
                .excludePathPatterns("/api/login"); // 排除 /api/login

        registry.addInterceptor(secondInterceptor)
                .addPathPatterns("/admin/**"); // 仅拦截 /admin/** 的请求
    }
}
```