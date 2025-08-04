# GitHub博客文章上传脚本使用说明

## 简介

`upload-blog-posts.sh` 脚本允许你在不维护本地git仓库的情况下，直接将本地目录中的Markdown文件上传到GitHub仓库。

## 特性

1. **自动处理文件名和目录名中的空格**：
   - 脚本会自动将文件名和目录名中的空格替换为下划线
   - 在上传过程中会提示哪些文件名被修改

## 准备工作

1. **创建GitHub个人访问令牌**
   - 对于经典令牌：
     - 访问 https://github.com/settings/tokens
     - 点击 "Generate new token"
     - 选择 "repo" 权限
     - 生成令牌并保存
   - 对于细粒度令牌（推荐）：
     - 访问 https://github.com/settings/tokens?type=beta
     - 点击 "Generate new token"
     - 给令牌起一个描述性的名称
     - 选择令牌适用的资源：
       - 选择 "Only select repositories"
       - 然后选择你的博客仓库 `lance-hxw/lance-hxw.github.io`
     - 在权限部分，找到 "Repository permissions" 并设置：
       - **Contents**: 设置为 "Read and write"
     - 点击 "Generate token"
     - 复制生成的令牌并保存

2. **（可选）设置环境变量**
   为了避免每次运行脚本时都需要输入令牌，可以设置环境变量：
   ```bash
   export GITHUB_TOKEN=your_github_token_here
   ```
   
   建议将此行添加到你的 `~/.bashrc` 或 `~/.zshrc` 文件中，以便永久生效。

3. **确保系统已安装必要工具**
   - curl
   - base64

## 使用方法

1. **（可选）设置环境变量**
   ```bash
   export GITHUB_TOKEN=your_github_token_here
   ```

2. **运行脚本**
   ```bash
   cd /path/to/lance-hxw.github.io/scripts
   ./upload-blog-posts.sh
   ```

3. **按照提示操作**
   - 如果没有设置环境变量，需要输入GitHub个人访问令牌
   - 输入本地包含Markdown文件的目录路径
   - 输入目标目录（相对于blog/post/）

## 示例

假设你有以下本地文件结构：
```
/home/user/my-posts/
├── post1.md
├── post2.md
└── go-tutorials/
    ├── basic.md
    └── advanced.md
```

运行脚本后：
- 输入本地目录：`/home/user/my-posts`
- 输入目标目录：`我的文章/2023`

文件将被上传到：
```
blog/post/我的文章/2023/
├── post1.md
├── post2.md
└── go-tutorials/
    ├── basic.md
    └── advanced.md
```

上传的文件将在GitHub仓库中显示为commit，commit消息格式为：
- 新增文件：`upload-posts: add {目标路径}/{文件名}`
- 更新文件：`upload-posts: update {目标路径}/{文件名}`

## 注意事项

1. 脚本会自动处理文件的创建和更新
2. 上传完成后，GitHub Actions会自动重新生成文件列表
3. 网站部署需要几分钟时间

## 故障排除

### HTTP状态码 000
如果遇到"HTTP状态码: 000"错误，可能是以下原因：
1. 网络连接问题 - 检查互联网连接
2. 防火墙或代理阻止了请求
3. GitHub API暂时不可用

### 权限错误
如果遇到401或403错误：
1. 检查令牌是否正确
2. 确认细粒度令牌具有"Contents: Read and write"权限
3. 确认令牌适用于正确的仓库

### 文件上传失败
如果特定文件上传失败：
1. 检查文件名是否包含特殊字符
2. 确认文件大小不超过100MB
3. 尝试单独上传该文件以获取更详细的错误信息