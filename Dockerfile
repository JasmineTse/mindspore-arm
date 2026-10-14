# ============================================
# MindSpore ARM64 Docker 镜像（国内镜像源优化版）
# 包含: MindSpore, jieba, Flask
# 架构: linux/arm64
# ============================================
# 构建命令:
#   docker build --platform linux/arm64 -t mindspore-arm:latest .
# ============================================

# 基础镜像: Python 3.9 (ARM64)
# 方案1: 使用官方镜像（建议在 Docker daemon 配置镜像加速器）
# 方案2: 使用阿里云公开镜像（需要阿里云账号）
# 这里使用官方镜像，通过 apt/pip 国内源加速构建
FROM python:3.9-slim-bullseye

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    DEBIAN_FRONTEND=noninteractive

# 更换 APT 源为阿里云镜像（加速软件包下载）
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libgmp-dev \
    curl \
    wget \
    git \
    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 安装 Python 包（使用国内镜像源）
RUN set -eux; \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple; \
    pip config set install.trusted-host pypi.tuna.tsinghua.edu.cn; \
    pip install --no-cache-dir \
        jieba==0.42.1 \
        flask==3.0.0 \
        werkzeug==3.0.1; \
    ARCH=$(uname -m); \
    if [ "$ARCH" = "aarch64" ]; then \
        echo "Installing MindSpore for ARM64..."; \
        pip install --no-cache-dir \
            https://ms-release.obs.cn-north-4.myhuaweicloud.com/2.3.1/MindSpore/unified/aarch64/mindspore-2.3.1-cp39-cp39-linux_aarch64.whl \
            || pip install --no-cache-dir mindspore-cpu==2.3.1; \
    else \
        echo "Installing MindSpore for x86_64..."; \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    fi

# 验证安装
RUN python -c "\
import sys; \
print('Python version:', sys.version); \
import mindspore as ms; \
print('MindSpore version:', ms.__version__); \
import jieba; \
print('jieba version:', jieba.__version__); \
import flask; \
print('Flask installed successfully'); \
print('\\n✅ All packages installed successfully!')"

# 创建应用目录
RUN mkdir -p /app/logs /app/data

# 暴露 Flask 默认端口
EXPOSE 5000

# 设置 Flask 环境变量
ENV FLASK_APP=app.py \
    FLASK_RUN_HOST=0.0.0.0 \
    FLASK_RUN_PORT=5000 \
    FLASK_DEBUG=0

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import mindspore, jieba, flask" || exit 1

# 标签信息
LABEL maintainer="your-email@example.com" \
      version="1.0" \
      description="MindSpore ARM64 Docker Image with jieba and Flask" \
      architecture="arm64"

# 默认启动命令
CMD ["python"]