# MindSpore ARM 镜像 - 快速开始指南

## 你的 GitHub 账号信息
- 用户名: jasminetse
- 仓库: mindspore-arm

## 第一步：创建 GitHub 仓库

点击这个链接直接创建：
https://github.com/new?name=mindspore-arm&visibility=public

设置：
- Repository name: mindspore-arm
- 选择 Public
- **不要**勾选任何初始化选项
- 点击 "Create repository"

## 第二步：创建 Personal Access Token

点击这个链接：
https://github.com/settings/tokens/new

填写：
- Note: MindSpore ARM Build
- Expiration: 90 days 或更长
- Select scopes: 勾选 ✅ repo, ✅ write:packages, ✅ workflow

点击 "Generate token"，复制生成的 token（ghp_ 开头的字符串）

## 第三步：推送代码

在命令行执行：
```bash
git remote add origin https://jasminetse:你的token@github.com/jasminetse/mindspore-arm.git
git push -u origin master
```

## 第四步：查看构建

访问：https://github.com/jasminetse/mindspore-arm/actions

等待构建完成（约 10-15 分钟）

## 第五步：拉取镜像

```bash
docker pull ghcr.io/jasminetse/mindspore-arm:latest
```
