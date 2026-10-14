# 📤 手动上传文件到 GitHub

由于网络问题无法自动推送，请按以下步骤手动创建：

## 第一步：创建仓库

1. 访问：https://github.com/new
2. Repository name: `mindspore-arm`
3. 选择 **Public**
4. 点击 **Create repository**

---

## 第二步：创建文件

### 文件 1: Dockerfile

在仓库页面点击 **"Add file" → "Create new file"**

File name 输入：`Dockerfile`

复制以下内容粘贴：

```dockerfile
# MindSpore ARM64 Docker 镜像
FROM python:3.9-slim-bullseye

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# 更换为阿里云 APT 源
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc g++ gfortran \
    libopenblas-dev liblapack-dev libgmp-dev \
    curl wget git pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 安装 Python 包（使用清华 PyPI 镜像）
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir jieba==0.42.1 flask==3.0.0 werkzeug==3.0.1 && \
    ARCH=$(uname -m); \
    if [ "$ARCH" = "aarch64" ]; then \
        pip install --no-cache-dir https://ms-release.obs.cn-north-4.myhuaweicloud.com/2.3.1/MindSpore/unified/aarch64/mindspore-2.3.1-cp39-cp39-linux_aarch64.whl || \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    else \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    fi

# 验证安装
RUN python -c "import mindspore, jieba, flask; print('✅ All packages installed!')"

EXPOSE 5000
ENV FLASK_APP=app.py FLASK_RUN_HOST=0.0.0.0
CMD ["python"]
```

点击 **"Commit new file"**

---

### 文件 2: GitHub Actions 工作流

点击 **"Add file" → "Create new file"**

File name 输入：`.github/workflows/build-arm-image.yml`
（输入 `.github/` 会自动创建目录）

复制以下内容：

```yaml
name: Build ARM Image

on:
  workflow_dispatch:
  push:
    branches: [main, master]

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read

    steps:
      - uses: actions/checkout@v4
      
      - uses: docker/setup-qemu-action@v3
      
      - uses: docker/setup-buildx-action@v3
      
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - uses: docker/build-push-action@v5
        with:
          context: .
          platforms: linux/arm64
          push: true
          tags: ghcr.io/${{ github.repository_owner }}/mindspore-arm:latest
```

点击 **"Commit new file"**

---

### 文件 3: README.md（可选）

File name: `README.md`

```markdown
# MindSpore ARM Docker 镜像

包含 MindSpore、jieba、Flask 的 ARM64 镜像。

## 拉取镜像
docker pull ghcr.io/jasminetse/mindspore-arm:latest

## 运行
docker run --rm -it ghcr.io/jasminetse/mindspore-arm:latest python
```

---

## 第三步：等待自动构建

1. 访问：https://github.com/jasminetse/mindspore-arm/actions
2. 查看构建进度（约 10-15 分钟）
3. 构建成功后拉取镜像：
   ```bash
   docker pull ghcr.io/jasminetse/mindspore-arm:latest
   ```

---

## ✅ 完成！

创建这 2-3 个文件后，GitHub Actions 会自动开始构建 ARM 镜像。
