# 手动上传文件到 GitHub

由于网络问题，我提供手动上传的方式：

## 方法 1: GitHub 网页上传

1. 访问你的仓库：https://github.com/jasminetse/mindspore-arm
   (如果没有，先创建：https://github.com/new)

2. 点击 "Add file" → "Upload files"

3. 上传以下文件：
   - Dockerfile
   - .github/workflows/build-arm-image.yml (需要先创建 .github/workflows 目录)
   - README.md
   - app.py
   - .gitignore

4. 填写 Commit 信息：Add MindSpore ARM Docker image

5. 点击 "Commit changes"

## 方法 2: 使用代理

如果你有代理（端口通常是 7890 或 1080）：

```bash
# 设置代理
export HTTP_PROXY=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890

# 推送
git push -u origin master
```

## 方法 3: GitHub CLI (推荐)

1. 下载安装 GitHub CLI:
   https://cli.github.com/

2. 登录：
   gh auth login

3. 创建仓库并推送：
   gh repo create mindspore-arm --public --source=. --push

## 上传成功后

访问 Actions 页面查看构建：
https://github.com/jasminetse/mindspore-arm/actions

等待 10-15 分钟，构建完成后拉取镜像：
docker pull ghcr.io/jasminetse/mindspore-arm:latest