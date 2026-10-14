# MindSpore ARM64 Docker 镜像（简化版）
FROM python:3.9-slim-bullseye

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# 更换为阿里云 APT 源（更稳定）
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list

# 分步安装系统依赖，便于调试
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libopenblas-dev \
    liblapack-dev \
    libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 包
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip config set install.trusted-host pypi.tuna.tsinghua.edu.cn

# 先安装基础包
RUN pip install --no-cache-dir \
    numpy \
    scipy \
    jieba==0.42.1 \
    flask==3.0.0 \
    werkzeug==3.0.1

# 安装 MindSpore（ARM64）
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
        echo "Installing MindSpore for ARM64..." && \
        pip install --no-cache-dir \
            https://ms-release.obs.cn-north-4.myhuaweicloud.com/2.3.1/MindSpore/unified/aarch64/mindspore-2.3.1-cp39-cp39-linux_aarch64.whl || \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    else \
        echo "Installing MindSpore for x86_64..." && \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    fi

# 验证安装
RUN python -c "import sys; print('Python:', sys.version)" && \
    python -c "import numpy; print('NumPy:', numpy.__version__)" && \
    python -c "import jieba; print('jieba:', jieba.__version__)" && \
    python -c "import flask; print('Flask installed')" && \
    python -c "import mindspore as ms; print('MindSpore:', ms.__version__)" && \
    echo "✅ All packages installed successfully!"

# 暴露端口
EXPOSE 5000

# 设置环境变量
ENV FLASK_APP=app.py \
    FLASK_RUN_HOST=0.0.0.0

# 默认命令
CMD ["python"]
