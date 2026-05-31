#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 第一階段：請 Gemini CLI 重構並修復兩大核心功能..."
echo "=========================================="

gemini-cli "你是一位擁有豐富除錯經驗的資深前端架構師。我們目前有一個使用 React + Tailwind CSS 寫成的「台灣國小期末評語生成器」index.html。請在保留原本 Dashboard 雙欄式架構（左側名冊管理、右側細節設定與批次複製）的前提下，精確重構並修正以下兩個功能：

1. 【修正：學生姓名需支援「逐個刪除」功能】
   - 目前點擊單一學生的刪除按鈕時會錯誤地導致全部學生被清空。請嚴格修正該處理函式（如 handleDeleteStudent），確保它是利用該學生的唯一識別碼（如 id 或唯一姓名），以 `students.filter(s => s.id !== targetId)` 的排除法邏輯，『僅刪除被點擊的那一個學生』，其餘學生的狀態、已選標籤與已生成評語必須完好保留、不受干擾。

2. 【新增：API Key 驗證與成功連線提示（Handshake Mechanism）】
   - 改善目前 API Key 綁定如同瞎子摸象的問題。在 API Key 的輸入框旁邊，新增一個「⚡ 測試連線」按鈕。
   - 點擊後，系統會立刻以該 Key 發送一個極輕量的測試請求給 Gemini API（例如請 gemini-2.5-flash 回傳一個 'OK' 字串）。
   - 【狀態回饋機制】：
     * 連線成功：跳出綠色成功的 Toast 提示或在欄位下方顯示「✅ 金鑰驗證成功，已正確與 Gemini 伺服器連線」，並解除生成按鈕的鎖定。
     * 連線失敗：精確擷取錯誤訊息（例如：403 權限錯誤、400 格式錯誤），跳出紅色警告提示「❌ 連線失敗，請檢查金鑰是否輸入正確或已過期」，引導老師排除故障。

【完整功能防呆保留要求】：
- 自訂標籤區塊必須維持乾淨的初始空陣列 []，徹底杜絕任何顯示為 'undefined' 且無法刪除的殘留標籤。
- 保留四大面向標籤（每類至少 10 個台灣小學專屬詞彙）、自訂標籤功能、導師補充建議欄（Teacher's Note Area）。
- 保留評語風格五種、字數限制、個別學生的「🔄 重新生成」與「復原/返回上一次評語」狀態追蹤。
- 視覺維持優雅的莫蘭迪暖色調。請直接輸出不省略、排版嚴謹、立即可執行的完整 index.html 程式碼。" > index.html

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
echo "🚀 第三階段：將修復後的完全體推送至 GitHub..."
echo "=========================================="

git add index.html deploy.sh 2>/dev/null
git commit -m "fix: 支援學生逐個刪除與新增 API Key 測試連線提示功能"
git push origin main

echo ""
echo "🎉 [版本迭代成功] 網頁已完成無縫熱更新！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 請在 30 秒後重新整理（Ctrl + F5）網址驗證新功能："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
