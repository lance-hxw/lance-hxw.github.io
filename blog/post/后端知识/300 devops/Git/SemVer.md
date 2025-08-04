在语义化版本控制(Semantic Versioning)中规定, 版本号的格式为 MAJOR.MINOR.PATCH, 如4.44.0
- MAJOR: 如果有BREAKING CHANGE, 不兼容以前版本, 应该递增MAJOR [[git_breaking_change]]
- MINOR: 如果新增功能但向下兼容 ,应该递增MINOR
- PATCH: 修bug且不带来兼容问题, 递增PATCH

## 其他特性

### 标签:
在三段版本后之后加上连字符和标识, 如: 
- 先行版本: 1.0.0-alpha, 2.0.0-beta.2
- 元数据: 1.0.0+001, 2.1.0+cu118
### 版本号比较
即两个SemVer版本号的大小(先后)比较
- 两个三位记号依次比较
- 先行版本比正式版更"旧", 即: 2.0.1-alpha<2.0.1
- 元数据不影响排序