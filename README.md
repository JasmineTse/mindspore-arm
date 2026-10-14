# MindSpore ARM Docker 镜像

包含 MindSpore、jieba、Flask 的 ARM64 架构 Docker 镜像。

## 📦 镜像内容

- **Python**: 3.9 (Debian Bullseye)
- **MindSpore**: 2.3.1 (CPU ARM64 版本)
- **jieba**: 中文分词库
- **Flask**: Web 框架

## 🚀 快速开始

### 1. 拉取镜像

```bash
# 从 GitHub Container Registry 拉取
docker pull ghcr.io/YOUR_USERNAME/mindspore-arm:latest
```

### 2. 运行容器

```bash
# 交互模式
docker run --rm -it ghcr.io/YOUR_USERNAME/mindspore-arm:latest python

# 测试所有包
docker run --rm ghcr.io/YOUR_USERNAME/mindspore-arm:latest python -c "import mindspore, jieba, flask; print('✓ All packages loaded!')"
```

### 3. 运行 Flask 应用

```bash
# 创建 app.py
docker run --rm -d -p 5000:5000 \
  -v $(pwd)/app.py:/app/app.py \
  ghcr.io/YOUR_USERNAME/mindspore-arm:latest \
  flask run
```

## 🔨 构建镜像

### 方法一：GitHub Actions 自动构建（推荐）

1. **创建 GitHub 仓库**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/mindspore-arm.git
   git push -u origin main
   ```

2. **触发构建**
   - 自动触发：推送代码到 main 分支
   - 手动触发：GitHub 仓库 → Actions → "Build ARM Image" → Run workflow

3. **查看构建状态**
   - GitHub 仓库 → Actions 标签页

### 方法二：本地构建（需要 Docker）

```bash
# ARM64 架构
docker build --platform linux/arm64 -t mindspore-arm:latest .

# AMD64 架构（测试用）
docker build --platform linux/amd64 -t mindspore-arm:amd64 .
```

## 📝 示例应用

### Flask + MindSpore + jieba 示例

```python
# app.py
from flask import Flask, jsonify
import jieba
import mindspore as ms

app = Flask(__name__)

@app.route('/')
def index():
    return {"message": "MindSpore ARM API"}

@app.route('/segment/<text>')
def segment(text):
    words = list(jieba.cut(text))
    return jsonify({"text": text, "words": words})

@app.route('/mindspore/info')
def mindspore_info():
    return jsonify({
        "version": ms.__version__,
        "device": "CPU"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

## 🏷️ 镜像标签

- `latest` - ARM64 最新版本
- `amd64` - AMD64 版本（可选）

## 📋 系统要求

- ARM64 架构设备（如 Apple Silicon Mac、ARM 服务器、树莓派等）
- Docker 或其他容器运行时

## ⚙️ 环境变量

- `FLASK_APP=app.py` - Flask 应用入口
- `FLASK_RUN_HOST=0.0.0.0` - Flask 监听地址

## 🔗 相关链接

- [MindSpore 官网](https://www.mindspore.cn/)
- [MindSpore GitHub](https://github.com/mindspore-ai/mindspore)
- [jieba GitHub](https://github.com/fxsjy/jieba)
- [Flask 官网](https://flask.palletsprojects.com/)

## 📄 许可证

MIT License