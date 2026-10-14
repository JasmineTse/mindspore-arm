from flask import Flask, jsonify
import jieba
import mindspore as ms

app = Flask(__name__)

@app.route('/')
def index():
    """首页 - API 状态检查"""
    return jsonify({
        "status": "ok",
        "message": "MindSpore ARM API is running",
        "packages": {
            "mindspore": ms.__version__,
            "jieba": jieba.__version__,
            "flask": "installed"
        }
    })

@app.route('/segment/<text>')
def segment(text):
    """中文分词接口"""
    words = list(jieba.cut(text))
    return jsonify({
        "text": text,
        "words": words,
        "count": len(words)
    })

@app.route('/mindspore/info')
def mindspore_info():
    """MindSpore 信息"""
    return jsonify({
        "version": ms.__version__,
        "device": "CPU",
        "backend": "mindspore"
    })

@app.route('/health')
def health():
    """健康检查"""
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    print("Starting MindSpore ARM Flask API...")
    print(f"MindSpore version: {ms.__version__}")
    print("Server running on http://0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000, debug=True)