# MindSpore ARM64 Docker 镜像（极简版）
FROM python:3.9-slim

WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# 使用清华 PyPI 镜像加速
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip config set install.trusted-host pypi.tuna.tsinghua.edu.cn

# 安装 Python 包（一次性安装）
RUN pip install --no-cache-dir \
    numpy \
    scipy \
    jieba==0.42.1 \
    flask==3.0.0 \
    werkzeug==3.0.1

# 安装 MindSpore ARM64 版本
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
        pip install --no-cache-dir \
            https://ms-release.obs.cn-north-4.myhuaweicloud.com/2.3.1/MindSpore/unified/aarch64/mindspore-2.3.1-cp39-cp39-linux_aarch64.whl || \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    else \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    fi

# 验证安装
RUN python -c "import mindspore, jieba, flask, numpy; print('✅ All packages installed successfully!')"

# 暴露端口
EXPOSE 5000

# 设置环境变量
ENV FLASK_APP=app.py \
    FLASK_RUN_HOST=0.0.0.0

# 默认命令
CMD ["python"]
