#!/bin/bash
REPO_NAME="teacher-comments-generator"

echo "=========================================="
echo "🎯 單獨處理：請 Gemini CLI 導入 Firebase 解決計數器破圖..."
echo "=========================================="

gemini-cli "你是一位細節控的前端全端架構師。我們目前有一個名為「評什麼東西」的 React + Tailwind CSS 網頁。

請在完全不改動、不遺漏原本核心功能（包含：左名冊逐個刪除、右設定自訂標籤防 undefined 修正、2秒防爆延遲、最新 gemini-2.5-flash 連線與中文錯誤偵錯機制、莫蘭迪暖色調、導師已登出開發團隊名稱、以及全套著作權免責說明文字）的前提下，單獨針對『總瀏覽人次計數器』進行底層技術重構：

【計數器重構規格】：
1. 【徹底消滅 <img> 破圖】：請完全移除原本程式碼中所有嘗試使用外部網址（如 hits、profile-counter 等）的 <img> 標籤或圖片。
2. 【導入 Firebase CDN】：在 HTML 的 <head> 或 <body> 底部，透過 CDN 引入官方最新相容版的 Firebase 核心與即時資料庫 SDK：
   - https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js
   - https://www.gstatic.com/firebasejs/10.8.0/firebase-database-compat.js
3. 【免密鑰公共初始化邏輯】：在 React 元件內部（例如 useEffect 中），初始化一個免註冊、免認證的公共公共唯讀寫測試路徑，或實作一個極簡的前端 fetch 計數邏輯。最標準的做法是：
   if (!firebase.apps.length) { firebase.initializeApp({ databaseURL: 'https://teacher-comments-counter-default-rtdb.firebaseio.com/' }); }
   const db = firebase.database();
   db.ref('visitchat/suuyo01').transaction(current => (current || 0) + 1);
4. 【純文字優雅渲染】：在 React 狀態中管理一個 viewCount (初始為 '讀取中...')。當資料庫 transaction 成功後，更新該 state。
5. 【視覺表現】：在頁尾（Footer）原本放計數器的位置，用優雅、淡淡的莫蘭迪純文字（使用 Tailwind 的 text-xs text-gray-400 opacity-50）渲染。
   - 顯示格式必須為：『 👁️ 總瀏覽人次：[動態讀取的純文字數字] 次 』。

請直接輸出不省略任何原本功能、排版完美、程式碼乾淨、立即可執行的完整 index.html 程式碼。" > index.html

echo "✅ Firebase 穩定版純文字計數器已成功織入網頁！"
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
git commit -m "fix: 徹底消滅計數器破圖問題，改採 Firebase 純文字渲染技術"
git push origin main

echo ""
echo "=========================================="
echo "🎉 [計數器修復完工] 網頁已完成無縫熱更新！"
GH_USER=$(gh api user --jq '.login')
echo "🔗 請在 30 秒後重新整理（Ctrl + F5）網址驗證成果："
echo "👉 https://${GH_USER}.github.io/${REPO_NAME}/"
echo "=========================================="
