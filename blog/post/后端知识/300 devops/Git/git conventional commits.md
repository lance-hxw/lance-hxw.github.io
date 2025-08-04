git conventional commits是一个 based heavily on the Angular Commit Guidelines的规范
其主要出发点是让commit msg变得人类和机器都可读
## 基本内容

```python
<type>(optional scope): <description>

[optional body]

[optional footer(s)]
```
## type
常用前缀包括: 
- fix: 修复bug
- feat: 增加新feature
- 其他 如: 
	- build: 修改build过程和打包发布
	- chore: 杂活, 不影响代码, 如依赖, 配置 修改注释文档
	- ci: 持续集成
	- docs: 文档
	- style: 代码风格
	- refactor: 重构, 不改变功能, 优化代码
	- perf: 提升性能
	- test: 修改测试
## footers
- breaking change: 写在footer, BREAKING CHANGE, 或者在type后面加一个!
- 可以遵循[Git - git-interpret-trailers Documentation (git-scm.com)](https://git-scm.com/docs/git-interpret-trailers)

## 优势
- 人看起来方便
- 有规范后, 便于自动化脚本处理log
- 更方便的版本控制(差异)
## 例子

>1. 新增一个feature, 破坏性
>>feat: allow xxx to extend xxx
>><空行>
>>BREAKING CHANGE: "extend" key is now used for extending other config files
>或者
>>feat!: send an email

>2. 带上scope
>>feat(api)!: send an email

>3. 多段body+多个footer
>>fix: prevent racing of requests
>><空行>
>>Introduce a request id and a reference to latest request Dismiss icoming responses others than from latest requet.
>><空行>
>>Remove timeous which were used o mitigate the racing issue but are obsolete now.
>><空行>
>>Reviewed-by: Z
>>Refs: #123

## Specification
- 必须用type前缀, 是一个动词
- 使用feat和fix表示添加新功能和修复bug
- type后面可以有个作用域 ,是一个名词, 它应该能指代项目中涉及的东西
- description应该跟在前缀的一个冒号和空格后
- 简短的描述后可以用更长的正文详细描述, 需要在第一行后再空一个空行开始
- footer和正文类似, 在第一行后空一个空行后开始, 可以有任意多个
- footer的前缀中, 应该*用-代替空格(以区分与正文)*, 如Reviewed-by, 然后用冒号空格, 或者冒号空格sharp隔开 ,后面加上描述
- **不区分大小写, 除了作为footer的BREAKING CHANGE或者BREAKING-CHANGE**
- 当使用!表示breaking change时, 脚注中的BREAKING CHANGE可以被省略, 第一行的description会被用来描述这个BREAKING CHANGE

## Ref.
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
[Git Commit 规范 | Feflow (feflowjs.com)](https://feflowjs.com/zh/guide/rule-git-commit.html)
