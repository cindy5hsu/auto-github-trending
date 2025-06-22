# GitHub Trending 資料擷取項目

影片鏈接 ： https://youtu.be/EnpKTWXVZuQ
 
## 專案簡介
這是一個用於抓取 GitHub Trending 頁面資料的全端應用程式專案。專案可以自動取得並儲存 GitHub 每日和每週熱門專案的數據，並透過現代化的 Web 介面展示這些資訊。

## 技術堆疊
- **前端框架**: Next.js 14 (App Router)
- **UI 元件**: Shadcn UI
- **資料庫 ORM**: Prisma
- **資料庫**: PostgreSQL
- **樣式方案**: Tailwind CSS

## 核心功能

### 1. 資料抓取服務
- 自動抓取 GitHub Trending 頁面數據
- 支援每日和每週熱門項目數據獲取
- 定時任務自動更新數據
- 資料解析和清洗

### 2. 資料儲存層
- 使用 Prisma 設計高效率的資料模型
- 儲存項目基本資訊（姓名、描述、星標數等）
- 記錄歷史趨勢數據
- 支援資料版本管理

### 3. 展示層
- 響應式設計的現代化介面
- 數據視覺化展示
- 進階篩選和搜尋功能
- 項目詳情頁面

### 4. 附加功能
- 用戶收藏功能
- 資料匯出功能
- 趨勢分析報告
- 郵件通知服務

## 專案結構
```
/
├── app/ # Next.js 應用程式目錄
│ ├── api/ # API 路由
│ ├── components/ # UI 元件
│ ├── lib/ # 工具函數
│ └── pages/ # 頁面元件
├── prisma/ # Prisma 配置與模型
├── public/ # 靜態資源
├── scripts/ # 資料抓取腳本
└── types/ # TypeScript 類型定義
```

## 資料模型設計

### Repository
- id: 唯一識別符
- name: 倉庫名稱
- owner: 倉庫所有者
- description: 倉庫描述
- stars: 星標數
- forks: 分支數
- language: 主要程式語言
- url: 倉庫鏈接

### TrendingRecord
- id: 唯一識別符
- repositoryId: 關聯的倉庫 ID
- date: 記錄日期
- rank: 排名
- type: 趨勢類型（日榜/週榜）
- starsGained: 期間獲得的星標數

## 開發計劃

### 第一階段：基礎架構搭建
1. 專案初始化與依賴安裝
2. 資料庫模型設計和 Prisma 配置
3. 基礎 UI 元件搭建

### 第二階段：核心功能開發
1. 資料抓取服務實現
2. API 路由開發
3. 前端頁面開發

### 第三階段：功能完善
1. 數據視覺化實現
2. 使用者互動優化
3. 效能優化

### 第四階段：測試與部署
1. 單元測試編寫
2. 整合測試
3. 部署配置

## 注意事項
- 遵守 GitHub API 使用限制
- 確保數據的準確性和及時性
- 注重使用者體驗與介面美觀
- 保持程式碼的可維護性和可擴展性
