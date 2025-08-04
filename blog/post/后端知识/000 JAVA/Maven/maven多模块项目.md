即： 子pom会继承父pom中的属性
这种结构用于将一个大型项目分解为多个子项目（或模块），这些模块可以独立构建和管理，同时仍然归属于同一个父项目。Maven 通过 `pom.xml` 文件管理项目的依赖、构建配置和插件，所以每个模块和父项目都有自己的 `pom.xml` 文件。
##  **父项目（Parent Project）的 `pom.xml` 文件**
父项目的 `pom.xml` 是整个多模块项目的顶层配置文件。它通常起到以下作用：

- **定义通用的配置**：父项目中的 `pom.xml` 可以包含子项目共享的依赖、插件、版本管理等。这样，子项目就不需要重复这些配置。
- **模块的管理**：父项目会通过 `modules` 标签来定义所有子模块。子模块会被 Maven 自动识别并进行构建。

一个典型的父项目 `pom.xml` 可能如下：
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>parent-project</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging> <!-- 父项目的打包类型为 pom -->
    
    <modules>
        <module>module-a</module>
        <module>module-b</module>
        <module>module-c</module>
    </modules>

    <dependencyManagement>
        <dependencies>
            <!-- 在这里定义子项目通用的依赖 -->
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <!-- 在这里定义子项目通用的插件 -->
        </plugins>
    </build>
</project>
```
## 子项目（Module）的 `pom.xml` 文件
每个子项目（即模块）也有自己的 `pom.xml` 文件，它通常继承自父项目的 `pom.xml`，并根据自身需求定义特有的依赖、插件等。子项目的 `pom.xml` 文件中通常包含对父项目的引用。

例如，某个子项目 `module-a` 的 `pom.xml` 可能如下：
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!-- 子项目的 groupId 和 version 可以继承自父项目 -->
    <parent>
        <groupId>com.example</groupId>
        <artifactId>parent-project</artifactId>
        <version>1.0-SNAPSHOT</version>
        <relativePath>../pom.xml</relativePath> <!-- 指定父项目的路径 -->
    </parent>

    <artifactId>module-a</artifactId>
    
    <dependencies>
        <!-- 子项目特有的依赖 -->
    </dependencies>
</project>

```
## Maven 多模块项目的工作原理
在多模块项目中，Maven 的构建流程会如下运作：

- **模块管理**：父项目通过 `modules` 标签定义了所有子模块（如 `module-a`、`module-b`、`module-c`）。当你在父项目目录下运行 `mvn clean install` 等命令时，Maven 会递归地构建这些子模块。
- **继承关系**：子项目通过 `parent` 标签继承父项目的配置。这意味着子项目可以继承父项目中定义的所有依赖、插件和版本信息。这种继承关系可以减少代码的重复，集中管理依赖版本。
- **模块间依赖**：如果一个子模块依赖于另一个子模块，可以在 `dependencies` 中指定依赖。例如，`module-b` 可以依赖于 `module-a`，这样在构建 `module-b` 时，Maven 会自动先构建 `module-a`。

##  **多模块项目的典型应用场景**
- **微服务架构**：每个子模块可以代表一个独立的微服务项目，父项目用于管理这些微服务的共同依赖和配置。
- **大型系统的模块化开发**：对于大型的单体应用，可以将不同功能模块划分为多个子项目，这样每个模块可以独立开发和测试。
- **共享库**：在一些项目中，某些模块会被多个子模块共享，如公共库（common library），它们可以被其他子模块依赖。