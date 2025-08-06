# Lance的个人网站

除readme, 其他均为ai写的

## 项目结构

- `blog` 文章相关功能, post中即为具体文章文件夹, 还有个file-list.json文件为根据文件夹结构计算的元信息
- `scripts` 相关脚本, 生成file-list.json的脚本

## 添加文章

- 手动commit到post目录中, 只能用这个
- ~~或者用提供的脚本将本地目录上传到post目录~~目前不可用
- commit后会自动生成file-list.json

### 修改网站样式

- 编辑`index.html`和`blog/index.html`中的CSS样式
- 或者修改`_config.yml`文件更换Jekyll主题

## 部署

将代码推送到GitHub仓库的master分支后，GitHub Pages会自动构建并部署网站。

## todo list

### blog

- [ ] 尽可能恢复类obsidian的\[\[]]跳转
