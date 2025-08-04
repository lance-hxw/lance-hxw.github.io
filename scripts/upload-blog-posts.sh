#!/bin/bash

# GitHub API上传博客文章脚本
# 使用GitHub API直接上传文件到仓库，无需维护本地git仓库

# 配置变量
GITHUB_TOKEN="${GITHUB_TOKEN:-}"  # 从环境变量获取，如果不存在则为空
OWNER="lance-hxw"
REPO="lance-hxw.github.io"
BRANCH="master"

# 调试模式
DEBUG=${DEBUG:-false}

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的信息
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查必要工具
check_tools() {
    if ! command -v curl &> /dev/null; then
        print_error "未找到curl命令，请先安装curl"
        exit 1
    fi
    
    if ! command -v base64 &> /dev/null; then
        print_error "未找到base64命令"
        exit 1
    fi
}

# 获取GitHub令牌
get_token() {
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "请输入GitHub个人访问令牌（Personal Access Token）："
        echo "访问 https://github.com/settings/tokens 创建一个新的token"
        echo "需要repo权限"
        echo "或者设置环境变量GITHUB_TOKEN"
        read -s GITHUB_TOKEN
        
        if [ -z "$GITHUB_TOKEN" ]; then
            print_error "令牌不能为空"
            exit 1
        fi
    else
        print_info "使用环境变量中的GitHub令牌"
    fi
}

# 检查网络连接
check_network() {
    print_info "正在检查网络连接..."
    if ! curl -s --connect-timeout 10 https://api.github.com/meta > /dev/null; then
        print_error "无法连接到GitHub API，请检查网络连接"
        exit 1
    fi
    print_info "网络连接正常"
}

# 检查令牌有效性
check_token() {
    print_info "正在验证GitHub令牌..."
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "User-Agent: BlogUploadScript/1.0" \
        "https://api.github.com/user")
    
    if [ "$RESPONSE" != "200" ]; then
        print_error "GitHub令牌验证失败，HTTP状态码: $RESPONSE"
        if [ "$RESPONSE" = "401" ]; then
            print_error "请检查令牌是否正确，以及是否具有足够的权限"
        elif [ "$RESPONSE" = "403" ]; then
            print_error "令牌权限不足，请检查细粒度令牌的配置"
            echo "对于细粒度令牌，请确保设置："
            echo "  1. 选择了正确的仓库 ($OWNER/$REPO)"
            echo "  2. Repository permissions -> Contents: Read and write"
        fi
        exit 1
    fi
    
    print_info "GitHub令牌验证成功"
}

# 检查令牌权限（专门针对细粒度令牌）
check_token_permissions() {
    print_info "正在检查令牌权限..."
    
    # 尝试访问仓库内容以验证权限
    local response
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "User-Agent: BlogUploadScript/1.0" \
        "https://api.github.com/repos/$OWNER/$REPO/contents/README.md")
    
    local http_code
    http_code=$(echo "$response" | tail -n 1)
    
    local response_content
    response_content=$(echo "$response" | sed '$d')
    
    # 200表示成功访问，404表示文件不存在但权限足够，403表示权限不足
    if [ "$http_code" = "403" ]; then
        print_error "令牌权限不足，无法访问仓库内容"
        echo "对于细粒度令牌，请确保设置："
        echo "  1. 选择了正确的仓库 ($OWNER/$REPO)"
        echo "  2. Repository permissions -> Contents: Read and write"
        echo "详细响应: $response_content"
        exit 1
    elif [ "$http_code" = "404" ]; then
        print_info "令牌权限检查通过（文件不存在但有访问权限）"
    elif [ "$http_code" = "200" ]; then
        print_info "令牌权限检查通过"
    else
        print_warn "权限检查返回意外状态码: $http_code"
        echo "响应详情: $response_content"
    fi
}

# 检查仓库是否存在
check_repo() {
    print_info "正在验证仓库信息..."
    local response
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "User-Agent: BlogUploadScript/1.0" \
        "https://api.github.com/repos/$OWNER/$REPO")
    
    local http_code
    http_code=$(echo "$response" | tail -n 1)
    
    local response_content
    response_content=$(echo "$response" | sed '$d')
    
    if [ "$http_code" != "200" ]; then
        print_error "仓库验证失败 (HTTP状态码: $http_code)"
        echo "响应详情: $response_content"
        exit 1
    fi
    
    print_info "仓库验证成功"
    
    if [ "$DEBUG" = true ]; then
        echo "仓库信息:"
        echo "$response_content" | jq '.' 2>/dev/null || echo "$response_content"
    fi
}

# 检查分支是否存在
check_branch() {
    print_info "正在验证分支信息..."
    local response
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "User-Agent: BlogUploadScript/1.0" \
        "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH")
    
    local http_code
    http_code=$(echo "$response" | tail -n 1)
    
    local response_content
    response_content=$(echo "$response" | sed '$d')
    
    if [ "$http_code" != "200" ]; then
        print_error "分支验证失败 (HTTP状态码: $http_code)"
        echo "响应详情: $response_content"
        exit 1
    fi
    
    print_info "分支验证成功"
}

# 上传单个文件
upload_file() {
    local file_path=$1
    local target_path=$2
    local filename=$(basename "$file_path")
    
    # 处理文件名中的空格，将其替换为下划线
    local safe_filename="${filename// /_}"
    
    # 如果文件名被修改了，输出提示信息
    if [ "$filename" != "$safe_filename" ]; then
        print_info "文件名包含空格，已替换为下划线: $filename -> $safe_filename"
        filename="$safe_filename"
    fi
    
    print_info "正在上传文件: $filename 到 $target_path"
    
    # 检查文件大小
    local file_size
    file_size=$(stat -c %s "$file_path" 2>/dev/null || stat -f %z "$file_path" 2>/dev/null)
    if [ "$file_size" -gt 100000000 ]; then  # 100MB
        print_error "文件过大: $filename ($(numfmt --to=iec $file_size))"
        return 1
    fi
    
    # 读取文件内容并进行base64编码
    local content
    content=$(base64 -i "$file_path" | tr -d '\n')
    
    # 检查编码后的内容长度
    if [ ${#content} -gt 100000000 ]; then  # 100MB
        print_error "文件编码后过大: $filename"
        return 1
    fi
    
    # 显示调试信息
    if [ "$DEBUG" = true ]; then
        print_info "调试信息:"
        echo "  文件路径: $file_path"
        echo "  目标路径: $target_path"
        echo "  文件名: $filename"
        echo "  文件大小: $file_size 字节"
        echo "  编码后长度: ${#content} 字符"
        echo "  API URL: https://api.github.com/repos/$OWNER/$REPO/contents/$target_path/$filename"
    fi
    
    # 检查文件是否已存在
    local file_exists=false
    local sha=""
    
    # 获取文件的SHA（如果文件存在）
    local get_response
    get_response=$(curl -s -w "
%{http_code}" \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "User-Agent: BlogUploadScript/1.0" \
        "https://api.github.com/repos/$OWNER/$REPO/contents/$target_path/$filename")
    
    # 提取HTTP状态码（最后一行）
    local get_http_code
    get_http_code=$(echo "$get_response" | tail -n 1)
    
    # 提取响应内容（除最后一行外的所有内容）
    local get_response_content
    get_response_content=$(echo "$get_response" | sed '$d')
    
    if [ "$DEBUG" = true ]; then
        echo "  文件存在性检查状态码: $get_http_code"
        if [ "$get_http_code" != "200" ] && [ "$get_http_code" != "404" ]; then
            echo "  文件存在性检查响应: $get_response_content"
        fi
    fi
    
    if [ "$get_http_code" = "200" ]; then
        file_exists=true
        sha=$(echo "$get_response_content" | grep '"sha"' | cut -d '"' -f 4)
        print_info "文件已存在，将更新文件"
    elif [ "$get_http_code" = "404" ]; then
        print_info "文件不存在，将创建新文件"
    else
        print_warn "检查文件存在性时出错 (HTTP状态码: $get_http_code)"
        echo "响应详情: $get_response_content"
    fi
    
    # 准备请求数据
    local request_data
    if [ "$file_exists" = true ]; then
        # 文件存在，更新文件
        request_data="{\"message\":\"upload-posts: update $target_path/$filename\",\"content\":\"$content\",\"branch\":\"$BRANCH\",\"sha\":\"$sha\"}"
    else
        # 文件不存在，创建新文件
        request_data="{\"message\":\"upload-posts: add $target_path/$filename\",\"content\":\"$content\",\"branch\":\"$BRANCH\"}"
    fi
    
    # 显示请求数据（调试模式下，但隐藏敏感内容）
    if [ "$DEBUG" = true ]; then
        echo "  请求数据 (隐藏content): $(echo "$request_data" | sed 's/"content":"[^"]*"/"content":"[HIDDEN]"/')"
    fi
    
    # 使用GitHub API上传文件
    local response
    response=$(curl -s -w "
%{http_code}" \
        -X PUT \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -H "User-Agent: BlogUploadScript/1.0" \
        -d "$request_data" \
        "https://api.github.com/repos/$OWNER/$REPO/contents/$target_path/$filename")
    
    # 提取HTTP状态码（最后一行）
    local http_code
    http_code=$(echo "$response" | tail -n 1)
    
    # 提取响应内容（除最后一行外的所有内容）
    local response_content
    response_content=$(echo "$response" | sed '$d')
    
    if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
        print_info "文件上传成功: $filename"
        return 0
    else
        print_error "文件上传失败: $filename (HTTP状态码: $http_code)"
        echo "请求URL: https://api.github.com/repos/$OWNER/$REPO/contents/$target_path/$filename"
        echo "请求数据: $request_data"
        echo "响应详情: $response_content"
        return 1
    fi
}

# 上传目录中的所有md文件
upload_directory() {
    local local_dir=$1
    local target_dir=$2
    
    # 检查本地目录是否存在
    if [ ! -d "$local_dir" ]; then
        print_error "本地目录不存在: $local_dir"
        exit 1
    fi
    
    # 处理目标目录路径中的空格
    local safe_target_dir="${target_dir// /_}"
    if [ "$target_dir" != "$safe_target_dir" ]; then
        print_info "目标目录名包含空格，已替换为下划线: $target_dir -> $safe_target_dir"
        target_dir="$safe_target_dir"
    fi
    
    # 计算目标路径
    local blog_target_path="blog/post/$target_dir"
    
    print_info "开始上传目录: $local_dir"
    print_info "目标路径: $blog_target_path"
    
    # 统计文件数量
    local file_count=0
    local success_count=0
    
    # 遍历目录中的所有md文件
    for file in "$local_dir"/*.md; do
        if [ -f "$file" ]; then
            file_count=$((file_count + 1))
            if upload_file "$file" "$blog_target_path"; then
                success_count=$((success_count + 1))
            fi
        fi
    done
    
    # 检查子目录
    for dir in "$local_dir"/*/; do
        if [ -d "$dir" ]; then
            local subdir_name
            subdir_name=$(basename "$dir")
            
            # 处理子目录名中的空格
            local safe_subdir_name="${subdir_name// /_}"
            if [ "$subdir_name" != "$safe_subdir_name" ]; then
                print_info "子目录名包含空格，已替换为下划线: $subdir_name -> $safe_subdir_name"
                subdir_name="$safe_subdir_name"
            fi
            
            local subdir_target="$target_dir/$subdir_name"
            
            print_info "处理子目录: $subdir_name"
            
            # 递归处理子目录
            upload_directory "$dir" "$subdir_target"
        fi
    done
    
    print_info "上传完成！成功上传 $success_count/$file_count 个文件"
}

# 主函数
main() {
    print_info "GitHub博客文章上传脚本"
    
    # 检查必要工具
    check_tools
    
    # 检查网络连接
    check_network
    
    # 获取并验证令牌
    get_token
    check_token
    
    # 验证令牌权限
    check_token_permissions
    
    # 验证仓库和分支
    check_repo
    check_branch
    
    # 获取用户输入
    echo ""
    echo "请输入本地目录路径（包含Markdown文件）："
    read LOCAL_DIR
    
    echo "请输入目标目录（相对于blog/post/，例如：技术文章/Go语言）："
    read TARGET_DIR
    
    # 确认操作
    echo ""
    echo "确认上传信息："
    echo "  本地目录: $LOCAL_DIR"
    echo "  目标目录: blog/post/$TARGET_DIR"
    echo ""
    echo "是否继续？(y/N)"
    read confirm
    
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "操作已取消"
        exit 0
    fi
    
    # 执行上传
    upload_directory "$LOCAL_DIR" "$TARGET_DIR"
    
    print_info "所有文件已上传完成！"
    echo "GitHub Actions将自动重新生成文件列表并部署网站。"
}

# 执行主函数
main "$@"
