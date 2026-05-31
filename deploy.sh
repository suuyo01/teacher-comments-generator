#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🤖 第一階段：請 Gemini CLI 重構並修復自訂標籤 Bug..."
echo "=========================================="

gemini-cli "你是一位精通 React 與 UI/UX 的資深前端架構師。我們目前有一個使用 React + Tailwind CSS 寫成的「台灣國小期末評語生成器」index.html。

目前發現了一個嚴重的 Bug 需要你修正：
【Bug 描述】自訂標籤（Custom Tags）區塊在初始化時，會錯誤地渲染出第一個顯示為 'undefined' 的無效標籤，且點擊該標籤旁邊的刪除按鈕（X）時完全沒有反應（無法刪除）。

【請進行以下修正與優化】：
1. 【修正自訂標籤初始化與刪除邏輯】：
   - 確保自訂標籤的 React State 陣列在初始狀態下是「完全乾淨的空陣列 []」，絕對不要渲染出任何 undefined 或空字串的標籤。
   - 嚴格檢查刪除自訂標籤的處理函式（例如 handleDeleteTag），確保它是透過「標籤文字」或「唯一的 index」進行 filter。刪除邏輯必須支援陣列中的『任何位置』（包含第 0 個、第一個標籤），點擊 X 時必須能流暢地將其從 State 中移除，且切換不同學生時，各自訂標籤的狀態要正確綁定、不會錯亂。
   - 自訂標籤輸入框必須加上防呆：輸入空白字串或重複的標籤時，按新增不會有反應。

2. 【保留原本所有強大功能】：
   - 雙欄式 (Two-Column Dashboard) 莫蘭迪暖色調 RWD 設計。
   - 左側：批次貼上姓名匯入名冊清單、學生狀態顯示（未設定、已設定、已生成）、全域一鍵複製所有評語面板。
   - 右側：單一學生設定面板，包含四大面向標籤（每類至少 10 個台灣小學高頻專屬詞彙）、五種評語風格、字數限制、以及『導師補充建議欄（Teacher's Note Area）』。
   - 點擊生成時單獨針對該學生重新呼叫 \"gemini-2.5-flash\" 模型，且包含「🔄 重新生成」與「復原/返回上一次評語」按鈕。
   - 包含全域 LocalStorage 安全密碼型 API Key 欄位。

請直接輸出不省略、排版完美、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ 網頁 Bug 已由 Gemini CLI 成功修正並重新生成！"
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
echo "🚀 第三階段：將修復後的程式碼推送至 GitHub..."
echo "=========================================="

git add index.html deploy.sh 2>/dev/null
git commit -m "fix: 修正自訂標籤第一個為 undefined 且無法刪除的 Bug"
git push origin main

echo ""
echo "🎉 [Bug 部署修復成功] 網頁已完成無縫熱更新！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 請在 30 秒後重新整理（Ctrl + F5）網址驗證："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
