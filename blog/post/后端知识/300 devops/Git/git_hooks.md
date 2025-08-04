在git中使用hooks可以自动执行一些操作, 如进行规范审查, 避免不符合格式的提交

## 简单实践

首先, 在项目的./git/hooks目录中, 创建一个pre-commit钩子文件
```bash
cd project/.git/hooks
touch pre-commit
```
在运行git commit前, 会触发这个钩子
pre-commit的内容:
```bash
#!/bin/bash

# 运行代码检查，确保符合规范
echo "Running code format check..."

# 使用 flake8 检查 Python 文件是否符合 PEP8 规范
files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')
if [ "$files" ]; then
    flake8 $files
    if [ $? -ne 0 ]; then
        echo "Python code format check failed!"
        exit 1
    fi
fi

# 通过检查，允许提交
echo "Code format check passed."
exit 0

```
这个hooks脚本的功能是检查目前暂存的python文件, 如果不符合pep8, 就不准提交.
编写完成后, 设置权限:
```bash
chmod +x .git/hooks/pre-commit
```
然后就能生效
## 进一步使用
如果有多种格式检查工具, 如多种语言等, 且需要自动化 , 可以考虑使用pre-commit框架.
只需要在项目根目录编写yaml文件, 然后安装就行了