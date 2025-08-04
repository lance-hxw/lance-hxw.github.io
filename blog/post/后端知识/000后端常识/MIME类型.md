是http中的媒体类型表示法, 是表示文档类型和格式的标准化指示
## 标准格式
主类型/子类型

其中, 主类型有:
- text
- image
- application
	- 应用程序数据, 如application/json, /xml, /pdf等
- audio
- video
## 常用类型
- \*/\*, 通配符
- text/\*, 任何文本
- text/html, html文档
- text/plain, 纯文本, 无格式
## 常用实践
常用于http请求和响应的头部
- 请求中的accept字段
- 响应中的content-type字段