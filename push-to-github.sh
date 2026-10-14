#!/bin/bash
# MindSpore ARM 镜像 - GitHub 推送脚本

echo "======================================"
echo "MindSpore ARM Docker 镜像构建脚本"
echo "======================================"
echo ""

# 提示用户输入 GitHub 用户名
read -p "请输入你的 GitHub 用户名: " USERNAME

if [ -z "$USERNAME" ]; then
    echo "错误: 用户名不能为空"
    exit 1
fi

echo ""
echo "即将推送到: https://github.com/$USERNAME/mindspore-arm"
echo ""

# 添加远程仓库
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$USERNAME/mindspore-arm.git"

# 推送代码
echo "正在推送代码..."
git push -u origin master

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 推送成功！"
    echo ""
    echo "接下来："
    echo "1. 访问 https://github.com/$USERNAME/mindspore-arm/actions"
    echo "2. 查看构建进度（约 10-15 分钟）"
    echo "3. 构建完成后，拉取镜像："
    echo "   docker pull ghcr.io/$USERNAME/mindspore-arm:latest"
    echo ""
else
    echo ""
    echo "❌ 推送失败，请检查："
    echo "1. 是否已经在 GitHub 创建了仓库"
    echo "2. 是否有推送权限"
    echo ""
fi