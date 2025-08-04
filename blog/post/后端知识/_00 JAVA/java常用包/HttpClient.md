用于在java程序中发起http请求
- HttpClient接口
- HttpClients 构造httpClient对象
- CloseableHttpClient 实现接口
- HttpGet/Post 请求对象
使用流程:
 - 创建一个HttpClient对象
 - 创建Http请求对象
 - 使用execute发送请求
 - 解析数据
 - 关闭资源
特性: 
- 支持异步
- 支持ws
- 支持流式处理
- 支持连接池
最佳实践:
- 复用client实例
- 使用异步处理大量请求
- 使用appropriate的BodyHandler处理响应
常见场景:
- 创建和配置client
- 使用GetPost请求
- 处理异步请求
- 认证
- 文件上传
- 处理不同响应
## 例子
### 创建client
```java
HttpClient.newBuilder()
	.version(HttpClient.Version.HTTP_2) // http version
	.connectTimeout(Duration.ofSeconds(10))
	.followRedirects(HttpClient.Redirect.NORMAL) 
	.build();	
```

### 发送GET
```java
HttpRequest req= HttpRequest.newBuilder()
				.uri(URI.create(""))
				.header("Accept","application/json")
				.header("Content-Type","application/json")
				.GET()// default = GET
				.build();
// sync request
HttpResponse<String> rsp = client.send(
				req, 
				HttpResponse.BodyHandlers.ofString();
			)
System.out.println("Status Code:" + rsp.statusCode());
System.out.println("Res Body:" + rsp.body());

```
### 发送POST
```java
String body = "{k : v}"
HttpRequest req = HttpRequest.newBuilder()
					.uri(URI.create(""))
					.header()
// publisher					
.POST(HttpRequest.BodyPublishers.ofString(body))
					.build()
```

### 异步请求
```java
CompletableFuture<HttpResponse<String>> futureRsp = 
	client.sendAsync(req, ...)
	.thenApply(rsp -> {
		..println(rsp.statusCode());
		return rsp
	})
	.thenApply(HttpResponse::body)
	.thenAccept(..Out::println)
```
这里thenApply都是进行一次映射(流式处理)
thenAccept是结束, 这里传进去一个消费者并终结
这种语法是链式调用, 基于函数式接口

## 简易方法
```java
String json = HttpClientUtil.doGet(endpoint, body);
JSONObject jsonObject = JSON.parseObject(json);
jsonObject.getString("openid");
```