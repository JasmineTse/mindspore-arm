# 创建 GitHub Token 步骤

1. 访问：https://github.com/settings/tokens/new
2. 填写：
   - Note: "MindSpore ARM Build"
   - Expiration: 选择 "No expiration" 或 "Custom" 选一个较长时间
   - Select scopes: 勾选以下选项
     ✅ repo (全部)
     ✅ write:packages
     ✅ read:packages
     ✅ delete:packages
     ✅ workflow

3. 点击页面底部的 "Generate token"
4. **重要**：复制生成的 token（类似 ghp_xxxxxxxxxxxx），只显示一次

创建好后，告诉我 token（前几位就行，比如 ghp_abc...）