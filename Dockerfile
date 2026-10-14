# MindSpore ARM64 Docker 镜像（最小化版本）
FROM python:3.9-slim

WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# 使用清华 PyPI 镜像
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 安装核心 Python 包
RUN pip install --no-cache-dir jieba==0.42.1 flask==3.0.0

# 安装 MindSpore ARM64
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
        pip install --no-cache-dir \
            https://ms-release.obs.cn-north-4.myhuaweicloud.com/2.3.1/MindSpore/unified/aarch64/mindspore-2.3.1-cp39-cp39-linux_aarch64.whl; \
    else \
        pip install --no-cache-dir mindspore-cpu==2.3.1; \
    fi

# 验证
RUN python -c "import mindspore, jieba, flask; print('✅ 成功安装所有包!')"

EXPOSE 5000

ENV FLASK_APP=app.py \
    FLASK_RUN_HOST=0.0.0.0

CMD ["python"]
