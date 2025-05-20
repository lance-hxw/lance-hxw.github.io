java archive和web archive是打包java/web应用的压缩格式文件，包含一个应用的所有资源和配置文件
## JAR 文件内容
### 用途
- 打包java类文件， 方便分发和管理
- 打包库文件，供其他app使用
### 内容
- java类文件
- 资源文件， 如各种配置文件和静态资源
- META-INF目录， 存放各种元数据
	- 如MANIFEST.MF, 记录jar的基本信息，如版本号和入口类（可以没有）
即：
	- META-INF
	- com-xxx。。
	- resources
## WAR包
### 用途
是打包web应用的压缩格式，类似jar但更复杂

### 内容
- WEB-INF目录， 包含web应用的配置文件和类文件
	- web.xml是应用部署描述文件， 包括servlets，filters，listensers等等
	- classes， 包含编译后的java类文件
	- lib，第三方jar
	- tlds， 描述文件 
- 静态资源
即：
```
example.war
├── index.jsp
├── about.jsp
├── css/
│   └── styles.css
├── js/
│   └── script.js
├── images/
│   └── logo.png
└── WEB-INF/
    ├── web.xml
    ├── classes/
    │   └── com/
    │       └── example/
    │           └── MyServlet.class
    ├── lib/
    │   └── example-library.jar
    └── tlds/
        └── custom-tags.tld

```