# Lance的个人网站

这是一个基于GitHub Pages的个人网站项目，包含首页和博客功能。

## 项目结构

- `index.html`: 网站首页，包含导航按钮
- `blog/index.html`: 博客页面，用于渲染和展示Markdown文件
- `md/`: 存放Markdown格式的博客文章
  - `example.md`: 示例博客文章
  - `subfolder/another-example.md`: 子文件夹中的示例文章
  - `file-list.json`: 博客文件列表，用于生成文件树
- `_config.yml`: Jekyll配置文件

## 功能特点

- 简洁的首页设计，包含导航按钮
- 轻量级博客系统，使用纯前端JavaScript实现
- 支持按文件层级展示Markdown文章
- 响应式布局，适配不同设备

## 使用方法

### 添加新博客文章

1. 在`md`文件夹中创建新的Markdown文件或子文件夹
2. 更新`md/file-list.json`文件，添加新文件的路径信息
3. 提交并推送到GitHub仓库

### 修改网站样式

- 编辑`index.html`和`blog/index.html`中的CSS样式
- 或者修改`_config.yml`文件更换Jekyll主题

## 本地预览

由于该项目使用纯HTML和JavaScript实现，可以直接在浏览器中打开`index.html`文件进行预览。

如果需要完整的GitHub Pages环境，可以安装Jekyll并运行：

```
bundle install
bundle exec jekyll serve
```

## 部署

将代码推送到GitHub仓库的master分支后，GitHub Pages会自动构建并部署网站。

## 注意事项

- 博客系统使用前端JavaScript加载Markdown文件，确保文件路径正确
- 更新`file-list.json`文件时保持正确的JSON格式
- 图片等静态资源可以放在仓库中，通过相对路径引用
