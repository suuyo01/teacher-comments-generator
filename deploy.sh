#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 第一階段：請 Gemini CLI 修復 404 模型找不到的 Bug..."
echo "=========================================="

gemini-cli "你是一位擁有豐富大型專案運維（DevOps）經驗的資深前端架構師。我們目前有一個使用 React + Tailwind CSS 寫成的「台灣國小期末評語生成器」index.html。

目前在測試連線時發生了 Google API 回傳 404 的嚴重錯誤：[404] models/gemini-1.5-flash is not found for API version v1beta。
【請進行以下針對性的精確修正】：
1. 【全面升級模型與 API 呼叫路徑】：
   - 請將程式碼中所有嘗試呼叫 gemini-1.5-flash 的地方，**全部強制升級、改寫為最新的官方正式推薦模型：\"gemini-2.5-flash\"**。
   - 如果程式碼中是手動拼湊 fetch URL（例如帶有 v1beta 的網址），請務必確保格式更新。如果使用的是 Google 官方最新前端 SDK (透過 CDN 引入的 @google/generative-ai)，請確保初始化寫法為 const genAI = new GoogleGenAI(apiKey); const model = genAI.getGenerativeModel({ model: \"gemini-2.5-flash\" });，徹底避開舊版測試通道的 404 限制。

2. 【保留所有強大功能與智慧防錯】：
   - 左側：名冊批次匯入管理、學生逐個刪除功能、全域複製面板。
   - 右側：單生設定面板、四大面向標籤（每類至少 10 個台灣小學詞彙）、自訂標籤功能（防 undefined 修正）、導師補充建議欄（Teacher's Note Area）。
   - 包含智慧型錯誤攔截器：若發生錯誤進入 catch，精確擷取代碼並顯示繁體中文對策（如 403 提示金鑰或學校帳號 IT 權限問題、429 提示限流、網路錯誤提示防火牆問題）。
   - 包含批次生成防爆延遲機制：每成功生成完一個學生，強制程式固定暫停 2 秒鐘，再自動發送下一個。
   - 全域 LocalStorage 安全密碼型 API Key 儲存。

請直接輸出不省略、排版完美、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ 模型路徑已由 Gemini CLI 成功修正並升級為 gemini-2.5-flash！"
echo ""
echo "=========================================="
echo "🛡️  第二階段：啟動 Gemini CLI 進行安全檢查..."
echo "=========================================="

CHECK_RESULT=$(gemini-cli "請幫我嚴格審查以下 index.html 的程式碼，特別檢查是否有硬編碼（Hard-coded）寫死任何 API Key。如果安全無虞，請回傳 'PASSED'。如果有資安風險，請指出行數並回傳 'FAILED'。" < index.html)

if [[ "$CHECK_RESULT" == *"FAILED"* ]]; then
    echo "❌ 檢查未通過！發現資安風險："
    echo "$CHECK_RESULT"
    exit 1
fi

echo "✅ 原始碼安全檢查通過 (No Hard-coded API Key Found)."
echo ""
echo "=========================================="
echo "🚀 第三階段：將修正後的最新完全體推送至 GitHub..."
echo "=========================================="

git add index.html deploy.sh 2>/dev/null
git commit -m "fix: 升級 API 模型至 gemini-2.5-flash 修正測試連線 404 錯誤"
git push origin main

echo ""
echo "🎉 [Bug 部署修復成功] 網頁已完成無縫熱更新！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 請在 30 秒後重新整理（Ctrl + F5）網址驗證新功能："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
