# 示例博客文章

这是一篇示例博客文章，用于展示Markdown渲染功能。

## 介绍

这个博客系统使用纯前端JavaScript实现，可以自动渲染Markdown文件并按文件层级展示。

## 功能特点

- 轻量级设计，资源消耗低
- 支持Markdown语法
- 文件树结构展示
- 响应式布局

## 代码示例

```javascript
// 渲染Markdown内容
function renderMarkdown(content) {
  return marked.parse(content);
}
```

## 表格示例

| 特性 | 描述 |
|------|------|
| 轻量级 | 使用最少的依赖 |
| 易用性 | 简单直观的界面 |
| 兼容性 | 支持主流浏览器 |

## 总结

这个简单的博客系统可以满足基本的博客展示需求，同时保持资源消耗低。您可以根据需要添加更多Markdown文件到md文件夹中。