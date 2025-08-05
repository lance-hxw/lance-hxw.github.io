# 简介
多种认证方式
细粒度授权控制
支持SpEL
与springboot和mvc轻松集成

# SecurityContext
- 存储当前线程的安全信息， 如Authentication
- 保证请求安全性，提供身份信息进行访问控制
- 支持会话管理，基于HttpSession（结合jwt
- 可扩展，支持自定义认证机制（OAuth2， jwt
通过SecurityContextHolder提供对Context访问
他是一个ThreadLocal

操作有：
```java
获取当前线程Authentication
Authentication auth = SecurityContextHolder.getContext()
								.getAuthentication()

设置线程安全信息
Authentication auth = new UsernamePasswordAuthentication(userDetails,null,userDetails.getAuthorities());
SecurityContextHolder.getContext().setAuthentication(auth);


清除
SecurityContextHolder.clearContext();
```

## 生命周期
- 用户登录时创建身份信息存入Context
- 请求时调用验证
- 注销时clear

## 结合jwt
使用一个UsernaemPasswordAuthenticationToken存入Context随时调用。

# Authentication接口
是SpringSecurity的认证类
一般需要提供身份验证和权限集合
形式为(Object principal, Object credentials, Collection 权限集合)

有如下实现
- UsernamePasswordAuthenticationToken
	- 用户名密码token
- AnonymousAuthenticationToken
	- 未登录但是需要访问权限操作，就分配一个匿名然后判断有没有权限
- RememberMeAuthenticationToken
	- 保持登录状态
- PreAuthenticatedAuthenticationToken
	- 接入外部认证时
- JwtAuthenticationToken
	- 传入一个jwt
- OAuth2AuthenticationToken
- TestingAuthenticationToken
# GrantedAuthority
```java
public interface GrantedAuthority extends Serializable {
	String getAuthority(); 
}
```
这个接口会返回一个权限名称，权限如何组织就看这个String如何构造
最常用实现类是SimpleGrantedAuthority
一般来说， 使用时如果有多个权限， 就用一个GrantedAuthority集合表示

# 编写 SecurityConfiguration
在其中可以设置过滤器链条,进行权限控制
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/**").hasRole("ADMIN") // 仅管理员访问
                .requestMatchers("/user/**").authenticated()    // 需要登录
                .anyRequest().permitAll()                      // 其他请求放行
            )
            .formLogin(login -> login
                .loginPage("/login") // 指定登录页面
                .permitAll()
            )
            .logout(logout -> logout.permitAll()); // 允许所有人注销

        return http.build();
    }
}

```
一般要禁用CSRF
然后还要在前面加上跨域过滤器和jwt过滤器
# SS 中有什么拦截器过滤器
