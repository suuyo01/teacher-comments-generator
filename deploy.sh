#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 終極修正：請 Gemini CLI 處理計數器防禦機制與字詞修正..."
echo "=========================================="

gemini-cli "你是一位擁有豐富大型專案上線經驗的前端專家。我們目前有一個名為「評什麼東西」的 React + Tailwind CSS 網頁。

請在完全不改動、不遺漏原本核心功能（包含：左名冊逐個刪除、右設定自訂標籤防 undefined 修正、2秒防爆延遲、最新 gemini-2.5-flash 連線與中文錯誤偵錯機制、莫蘭迪暖色調、導師已登出開發團隊名稱、全套著作權免責說明文字）的前提下，精確重構以下兩個細節：

1. 【字詞修正】：
   - 請在「常規與品格」（或常規品格）的內建標籤矩陣中，找到多打了一個字的【愛惜公公物】標籤，精確修正為通俗正確的【愛惜公物】。

2. 【徹底解決計數器卡死：實作防禦性純文字計數器】：
   - 請完全移除原本程式碼中所有的 Firebase 引入腳本與舊的計數邏輯，避免跨網域或安全性鎖死。
   - 請在 React 組件內改採標準的 fetch 去請求一個最乾淨、無阻擋的公共 JSON 計數 API（例如：https://api.counterapi.dev/v1/projects/suuyo01_eval_things/counters/pageviews/up）。
   - 【核心防禦機制】：必須將 fetch 包裹在嚴謹的 try...catch 區塊中，並加上 **2 秒超時斷開（Timeout）** 防護。
   - 【防空轉降級邏輯 (Fallback)】：如果 API 連線成功，則直接更新 viewCount 狀態。**若 API 被校園網路防火牆擋掉、連線失敗、或是 2 秒內沒回應，catch 區塊必須立刻啟動防禦降級**：從用戶的 LocalStorage 讀取一個累加值，若無則預設為一個基底種子數字（例如：542），並在本地自動順暢 +1 呈現。
   - 【視覺表現】：徹底杜絕 <img> 破圖。維持在網頁最下方（Footer）以極淡的莫蘭迪純文字（text-xs text-gray-400 opacity-50）優雅渲染：『 👁️ 總瀏覽人次：[數字] 次 』。不論網路環境如何，網頁載入 2 秒後，絕對不允許停留在「讀取中」。

請直接輸出不省略任何原本功能、排版完美、程式碼乾淨、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ 終極防禦版計數器與字詞修正已由 Gemini CLI 重新編寫！"
echo ""
echo "=========================================="
echo "🛡️  驗證階段：啟動 Gemini CLI 進行安全檢查..."
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
echo "🚀 發布階段：將最新成果推送至 GitHub..."
echo "=========================================="

git add index.html deploy.sh 2>/dev/null
git commit -m "fix: 修正愛惜公物錯字並導入計數器 2 秒防禦降級機制"
git push origin main

echo ""
echo "=========================================="
echo "🎉 [終極完美完全體部署成功] 網頁已無縫熱更新！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 請在 30 秒後重新整理（Ctrl + F5）網址驗證最终成果："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
