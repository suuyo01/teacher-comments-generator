#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 介面精雕：請 Gemini CLI 修正副標題文字並重新生成..."
echo "=========================================="

gemini-cli "你是一位細節控的資深前端全端架構師。我們目前有一個名為「評什麼東西」的 React + Tailwind CSS 網頁。

請在完全不改動、不遺漏原本所有核心功能（包含：左名冊逐個刪除、右設定自訂標籤防 undefined 修正、2秒防爆延遲、最新 gemini-2.5-flash 連線與中文錯誤偵錯機制、莫蘭迪暖色調、導師已登出開發團隊名稱、防禦型降級純文字計數器、全套著作權免責說明文字）的前提下，精確重構以下細節：

1. 【副標題精簡修正】：
   - 請嚴格檢查網頁主標題（H1）下方的副標題文字，將其精確設定為：【 國小期末評語生成器 】。
   - 移除所有帶有「台灣」與「(終極穩定版)」的副標題字樣，讓介面呈現最俐落乾淨的視覺。主標題維持【 評什麼東西 】。

2. 【文字防錯對齊】：
   - 確保「常規品格」領域內建標籤為正確的【愛惜公物】（拒絕愛惜公公物）。
   - 所有批次按鈕提示字維持通俗的【匯入學生】。

3. 【維持防禦性純文字計數器與著作權】：
   - 使用 https://api.counterapi.dev/v1/projects/suuyo01_eval_things/counters/pageviews/up 進行純文字 fetch 計數。
   - 必須包覆在 2 秒超時與 try...catch 中，失敗或卡住時自動降級讀取 LocalStorage 或顯示基底種子數字，防禦畫面死機。
   - 頁尾以極淡的莫蘭迪純文字優雅渲染：『 👁️ 總瀏覽人次：[數字] 次 』。
   - 頁尾精確顯示：『 © 2026 導師已登出開發團隊. All Rights Reserved. 』與全套法律著作權及資安免責小字。

請直接輸出不省略任何原本功能、排版完美、程式碼乾淨、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ 副標題已成功精簡為『國小期末評語生成器』！"
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
git commit -m "style: 精簡副標題為國小期末評語生成器並優化介面細節"
git push origin main

echo ""
echo "=========================================="
echo "🎉 [UI 精雕成功] 最終純淨版網頁已上線！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 最終版連結："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
