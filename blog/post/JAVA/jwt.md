Json web token 是用于多方传递信息的简洁安全形式. 尤其被用于验证和授权场景

## jwt的结构: 头.载荷.签名
```css
header.payload.signature
#如 "eyJhbGciOiJIUzI1NiJ9.eyJlbXBJZCI6MSwiZXhwIjoxNzI5NTg2NzQ1fQ.wahPfZnEULPCLc22Izv_xgjJriGveXEuaqzEscXLe5I"
```
**头部**是指定使用的签名算法如:
```json
{
	"alg": "HS256", // 签名算法
	"typ": "JWT" //表示这是一个jwt
}
```
**payload**, 是实际数据(claims), 可以是用户id, 角色等等:
```json
{
	"sub": "123", // ID
	"name": "lance",
	"admin": true,
	"exp":  // 过期时间, UNIX时间戳, 如果不设置exp字段, 就不会过期, 测试时, 可以修改为非常久过期, 然后再改回去
}
```
**签名**, 用于验证令牌没有被篡改, 是将header和payload编码后和一个秘钥结合用指定算法加密的结果
如: HMACSHA256(base64UrlEncode(header))+"."+base64UrlEncode(payload),secret)

## 工作原理
1. 客户端登录: 用户提供凭据, 如账号密码给服务器
2. 服务器验证凭据, 然后生成一个JWT,包含了用户id信息和过期时间, 将jwt发给客户端
3. 客户端存储jwt, 存在localstorage或者sessionStorage中
4. 接下来客户端所有请求, 都将jwt放入http头的authorization字段: Bearer \<token\>
5. 服务器验证jwt的有效性, 并按照用户信息处理后续请求.

## 场景
1. 身份验证, 比如登录, 然后给用户他对应的数据
2. 授权, 在多权限系统中, 在payload中加入角色和权限, 可以对带有不同jwt的请求开放不同资源.

## 创建和验证

### 创建
```js
const jwt = require('jsonwebtoken');

const token = jwt.sign(
	{sub:'1231321', name: 'lance', admin: true },//payload
	'your secret key', // 秘钥
	{expires: '1h'} //过期时间
)
```
### 验证
```js
try{
	const decoded = jwt.verify(token, 'secret key' );
} catch (err) {
	console.error(" valid token " )
}
```
### 解析
```java
Claims claims = JwtUtil.parseJWT(jwtProperties.getAdminSecretKey(), token);  
Long empId = Long.valueOf(claims.get(JwtClaimsConstant.EMP_ID).toString());
```

## 优缺点:
- 无状态, 不需要在数据库中存用户状态, 直接在令牌中保存状态
- 通用,灵活,可扩展
- 但是一旦秘钥泄露, 所有jwt都不安全
- jwt体积比较大
- jwt不可撤销, 只能等过期
## 相似产品和功能
- Session-based A. 传统的基于状态的
- OAuth 2.0 授权
- Paseto 平台无关, 更安全
- SAML, 基于xml, 用于单点登录, 在企业级和B2B中用.
- ......
# J W T拦截器如何实现
一般是public class JwtInterceptor implements HandlerInterceptor
然后去webmvcConfigurer中注册

## HandlerInterceptor  与 OncePerRequestFilter

|**对比项**|**JwtInterceptor (HandlerInterceptor)**|**JwtAuthenticationFilter (OncePerRequestFilter)**|
|---|---|---|
|**作用层面**|作用于 Spring MVC 层面 (`Controller`)|作用于 `Servlet` 层面 (`Filter`)|
|**拦截范围**|仅拦截 **Spring MVC Controller** 方法|拦截 **所有 HTTP 请求**（包括静态资源等）|
|**执行时机**|在 Spring MVC 处理请求之前|在 `Servlet` 进入 `DispatcherServlet` 之前|
|**适用于**|权限控制、请求参数校验|认证、跨域（CORS）、全局日志等|
|**是否支持 Spring Security**|需要额外配置|可与 Security 直接集成|
|**能否拦截 `forward`、`include`**|不能|可以|
|**如何注册**|`WebMvcConfigurer#addInterceptors`|`SecurityFilterChain#addFilterBefore` 或 `FilterRegistrationBean`|