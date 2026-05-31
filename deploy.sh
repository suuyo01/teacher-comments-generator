#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 第一階段：請 Gemini CLI 進行細節打磨、版權與計數器織入..."
echo "=========================================="

gemini-cli "你是一位細節控的資深前端架構師與 UI/UX 專家。我們目前有一個 React + Tailwind CSS 的「台灣國小期末評語生成器」index.html。

請在保留目前完整健康架構（左名冊、右設定、自訂標籤功能、學生逐個刪除、API Key 連線中文偵錯、2秒防爆延遲、莫蘭迪暖色調）的前提下，精確重構並打磨以下產品細節：

1. 【詞彙通俗化與在地化修正】：
   - 請嚴格檢查網頁上的文字，將「特殊表現」分類裡的【擅長\"數位\"】標籤，精確修正為台灣校園更通俗的【擅長\"科技\"】。
   - 將所有按鈕、提示字眼中的「匯入生員」全面修正為台灣主流通俗用語【匯入學生】（例如：「批次匯入學生姓名」）。

2. 【新增：低調優雅的總閱覽人數計數器】：
   - 在網頁的最下方（或角落頁尾 Footer），新增一個淡淡的、完全不搶戲的總瀏覽人次計數器。
   - 使用 hits.seeyoufarm.com 或類似服務，透過 Tailwind 的 opacity-40 進行極淡的視覺融合，顯示為：『 👁️ 總瀏覽人次：[計數器] 』。

3. 【新增：專業版權與免責宣告】：
   - 在頁尾計數器的下方或旁邊，加上一行標準且精緻的版權宣告，例如：『 © 2026 台灣國小期末評語生成器開發團隊. All Rights Reserved. 』。
   - 在 API Key 輸入區或頁尾加註一行極小的安全免責字樣：『 🔒 本工具為純前端架構，您的 API Key 與學生資安資料皆儲存於您個人的瀏覽器本地端（LocalStorage），本站絕不收集或上傳任何隱私資訊，請安心使用。 』

請直接輸出不省略、排版完美、程式碼乾淨、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ 細節優化、台灣校園用語修正與計數器已成功寫入網頁！"
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
echo "🚀 第三階段：將全新完全體推送至 GitHub..."
echo "=========================================="

git add index.html deploy.sh 2>/dev/null
git commit -m "feat: 修正通俗用語、新增低調瀏覽計數器與版權隱私宣告"
git push origin main

echo ""
echo "🎉 [產品優化成功] 最終打磨版網頁已全面同步雲端！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 歡迎體驗產品化後的完美網址："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
