## accout: 账号登录
### 基本功能
- GetDID: 根据设备信息生成/获取DID
- GuestLogin: 游客账号登录注册， 一个设备对应一个游客
- Nonce， 获取一次性ID
- Auth：认证某个token
- CheckToken：校验token
- CreateAccout：内部创建账号
### 登录
密码登录，手机、邮箱验证码登录
绑定，解绑三方
等出
- DirectLogin
- OpenLogin：第三方
- Login：手机+密码
- LoginByVerifyCode
	- GetPhoneLoginCode
- LoginByEmailPw
- LoginByVerifyEmailCode
	- GetEmailLoginCode
- Logout
- UnbindThird 
### 改密码
分成登录状态下和非登录状态， 手机和邮箱，获取验证码然后修改
还有直接用老密码修改的
- ModifyPasswdBydOldPwd 
- GetPhonePwCode
- ModifyPasswd
- GetCodeFOrModifyPw
- ModifyPasswdByPhoneCode
- ...
### 修改：手机号， 邮箱， 
主要是获取另一个方式的验证码和校验

## app_crash： 一个崩溃上报接口

## applog：上传log和创建任务两个接口

## chat
- 获取用户设备连接信息，根据mid和应用名称查询其client
- 向指定client发送查询调试命令
	- log， env， data， reset
## email_auth
- sentauthcode， 发送验证码
- authcode，校验认证码
## frodo_accout
 frodo 相关的accout一套 这个路由会去frodoaccout/httpapi/do

## geo_api
地理和ip相关的一套

## maga？里面全是什么blackid
## mobius_auth_api
mobius的， 有个auth鉴权接口

## media


。。。。。。。。。。。。。。。。。



