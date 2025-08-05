在一个B/S结构中, 请求一个页面的流程为:
- browser与server建立TCP链接
- browser发送http请求
- 收取http响应, browser显示结果
这个过程中, 最重要协议是[[http协议与http服务器]]
但是光建立连接不够, 还需要处理连接状态和性能等, 如:
- 识别请求状态, 识别请求头状态
- 复用TCP连接
- 复用线程
- IOException处理
包括http服务器的各种处理(比如状态和路径等), 甚至tcp连接处理,可以通过协议把这些工作打包交给现有的web服务器做, 在java中, 这个协议就是servlet API.
通过这个API, 就可以利用tomcat等实现了API的web服务器
应用程序中持有一个servlet通过API与webserver交互, webserver和客户端通信.
这样, 就不用一行行在tcp中写了, 一个servlet如下:
```java
// WebServlet注解表示这是一个Servlet，并映射到地址/:
@WebServlet(urlPatterns = "/")// 这就是处理http请求第一行的路径得到的
public class HelloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 设置响应类型:
        resp.setContentType("text/html");
        // 获取输出流:
        PrintWriter pw = resp.getWriter();
        // 写入响应:
        pw.write("<h1>Hello, world!</h1>");
        // 最后不要忘记flush强制输出:
        pw.flush();
    }
}
```
可以看到, 继承一个httpservlet, 然后重写doGet和doPost, 在其中, 使用封装好的requset和response, 填入正确的值, 然后获取printwriter写入响应就行
servlet-api需要用maven引入.

定义好servlet就可以打包一个war(web jar)
- 其中java目录下最终包含servlet类
- webapp和resources中包含一些资源文件
这样, 一个web app的运行就是:
- 使用一个支持servlet的web服务器, 如tomcat
- web服务器加载编写的servlet
	- 把name.war放到tomcat的webapps下
	- 设置运行startup.sh
	- 此时, 就运行在ip:8080/name/下了
		- 一个web服务器可以运行多个服务, 所以是name/,而不是/
		- 需要直接用/, 可以改名ROOT.war, 作为默认应用
	- 其逻辑是, tomcat加载一个war文件创建servlet实例, 多线程处理http请求.

注意: 
- 在servlet容器如tomcat中运行的servlet服务需要:
	- 只要写servlet类, 实例化是容器来
	- 一个servlet一个容器中对应一个实例
	- doGet和doPost将多线程处理
- 所以:
	- servlet中定义的数据成员需要进程安全
	- 每个线程处理的一个req和rsp是局部变量, 不涉及多线程
	- doget和dopost中如果使用了threadLocal, 会影响下次请求, 因为servlet容器很可能用线程池来线程复用
## 常用实践;
- 给url加一个参数, 如/name/?name=a
	- doget中用:req.getParameter("name")
