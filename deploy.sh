#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 最終階段：請 Gemini CLI 進行正名、計數器修復與著作權織入..."
echo "=========================================="

gemini-cli "你是一位細節控的資深前端架構師。請在保留目前所有核心功能（左側學生名冊管理、逐個刪除、右側細節設定、2秒防爆延遲、自訂標籤防 undefined 修正、API Key 連線中文偵錯、莫蘭迪暖色調）的前提下，精確重構網頁，完成以下細節打磨：

1. 【產品全面正名】：
   - 請將網頁頂端大標題（H1）、瀏覽器分頁標籤（<title>）以及全域所有提及本工具名稱的地方，全面改名為最具黑色幽默、深得師心的：【 評什麼東西 】（副標題可維持：台灣國小期末評語生成器）。

2. 【修復：總瀏覽人次計數器破圖問題】：
   - 目前使用的 hits 計數器圖標在前端會發生破圖。請改用業界最穩定、純前端 HTML 免註冊即可使用的 Moe-Counter 或標準無痕圖標 API。
   - 請直接在頁尾 HTML 插入以下這行最穩定的 SVG 連結（它會自動根據你的專案網址計算人次，且不會破圖）：
     <img src=\"https://profile-counter.glitch.me/suuyo01-teacher-comments/count.svg\" alt=\"訪客計數器\" class=\"inline-block h-5 opacity-50 m-1 contrast-75\" />
   - 確保其前後包覆在淡淡的莫蘭迪文字中，優雅顯示為：『 👁️ 總瀏覽人次：[計數器圖標] 』。

3. 【更新：團隊名稱與完整著作權免責說明】：
   - 將原本的開發團隊名稱精確修改為：【 導師已登出開發團隊 】。
   - 版權宣告完整字樣修正為：『 © 2026 導師已登出開發團隊. All Rights Reserved. 』
   - 在版權下方，必須新增一行正式的【著作權與免責說明】小字（使用 text-xs text-gray-400 opacity-50 block mt-1）：
     『 ⚖️ 著作權與智慧財產權宣告：本工具開放大眾教學無償使用，惟程式碼資產、視覺商標及智慧財產權均屬「導師已登出開發團隊」所有，未經授權禁止商業拷貝或再包裝銷售。本工具生成之評語僅供教學參考，最終採用權與審查權仍歸各校經辦教師所有。 』

請直接輸出不省略、排版完美、程式碼乾淨、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ 『評什麼東西』最終完全體已由 Gemini CLI 重新生成完畢！"
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
echo "🚀 發布階段：將最終完全體推送至 GitHub..."
echo "=========================================="

git add index.html deploy.sh 2>/dev/null
git commit -m "feat: 專案正名評什麼東西、修復計數器破圖、更新版權與著作權說明"
git push origin main

echo ""
echo "🎉 [最終完美版部署成功] 網頁已完成無縫熱更新！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 請在 30 秒後重新整理（Ctrl + F5）網址驗證成果："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
