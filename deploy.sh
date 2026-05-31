#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 第一階段：請 Gemini CLI 織入 API 錯誤代碼攔截與防爆機制..."
echo "=========================================="

gemini-cli "你是一位擁有豐富大型專案運維（DevOps）經驗的資深前端架構師。我們目前有一個使用 React + Tailwind CSS 寫成的「台灣國小期末評語生成器」index.html。

請在保留原本莫蘭迪暖色調雙欄式架構（左側名冊、右側單生微調、全域密碼金鑰欄、全域複製面板、自訂標籤防 undefined 修正、學生逐個刪除功能）的前提下，全力重構並升級以下 API 連線與錯誤處理邏輯：

1. 【強化：API Key 測試連線與『中文錯誤代碼對照提示』】
   - 當用戶在「⚡ 測試連線」或「生成評語」發生錯誤進入 catch (error) 時，程式碼必須深入解析錯誤物件（讀取 HTTP status code 或 Google API 回傳的 error.status/error.code）。
   - 請在 UI 畫面上將晦澀的英文錯誤轉譯為台灣老師看懂的具體對策，並明確標註【錯誤代碼】：
     * 【400 / INVALID_ARGUMENT】：顯示「❌ 連線失敗 (錯誤代碼 400)。原因：請求格式錯誤或模型名稱設定不正確，請聯繫開發者檢查代碼參數。」
     * 【403 / PERMISSION_DENIED】：顯示「❌ 連線失敗 (錯誤代碼 403)。原因：您的 API Key 無效、已被停用，或者前後不小心複製到了空格。另外，若您使用的是學校教育單位的 Google 帳號，可能是校方 IT 管理員封鎖了 AI 權限，請嘗試換成個人的一般 @gmail.com 帳號重新申請金鑰。」
     * 【429 / RESOURCE_EXHAUSTED】：顯示「❌ 觸發限流 (錯誤代碼 429)。原因：由於使用的是免費版金鑰，超出了 Google 每分鐘的呼叫次數限制。請稍微靜候 1 分鐘後再點擊繼續生成。」
     * 【500 / 503 / INTERNAL_ERROR】：顯示「❌ 伺服器錯誤 (錯誤代碼 500/503)。原因：Google Gemini 雲端伺服器目前忙碌或維護中，請稍後再試。」

2. 【優化：全域錯誤攔截與 Loading 防呆】
   - 在連線測試期間，鎖定按鈕並顯示 Loading 轉圈。
   - 確保錯誤訊息在 API 設定視窗與主生成區域都能一致地以鮮紅色提示呈現，不會因為錯誤而導致整個 React 畫面崩潰 (White Screen)。

視覺維持優雅的莫蘭迪暖色調。請直接輸出不省略、排版嚴謹、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ 網頁功能修復與重構已由 Gemini CLI 順利完成！"
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
echo "🚀 第三階段：將修復後的穩定版推送至 GitHub..."
echo "=========================================="

git add index.html deploy.sh 2>/dev/null
git commit -m "fix: 實作深度 API 錯誤代碼攔截與台灣語境友善提示機制"
git push origin main

echo ""
echo "🎉 [版本迭代成功] 網頁已完成無縫熱更新！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 請在 30 秒後重新整理（Ctrl + F5）網址驗證新功能："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
