# 一键推送指南

## 步骤 1: 创建仓库（必须手动）
点击：https://github.com/new
- Repository name: mindspore-arm
- 选择 Public
- 不要勾选任何初始化选项
- 点击 Create repository

## 步骤 2: 确认创建完成
创建完成后，你会在浏览器看到类似这样的 URL：
https://github.com/jasminetse/mindspore-arm

## 步骤 3: 告诉我
回复："创建完成"

我会立即推送代码并触发自动构建。

---

预期结果：
✅ 代码推送到 GitHub
✅ GitHub Actions 自动开始构建 ARM64 镜像
✅ 10-15 分钟后镜像可用的地址：
   ghcr.io/jasminetse/mindspore-arm:latest