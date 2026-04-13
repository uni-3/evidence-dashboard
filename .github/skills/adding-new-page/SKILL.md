# 新しいページを追加する手順

## 概要
Evidence BIプロジェクトで新しいダッシュボードページを追加するための手順です。

## 手順

### 1. ページファイルの作成
`pages/` ディレクトリに新しい `.md` ファイルを作成します。

**パス例:** `pages/new-dashboard.md`

```markdown
---
title: ダッシュボード名
description: 説明文
---

# ダッシュボード名

ページの内容をここに記述します。
```

### 2. スキーマ確認（必要に応じて）
データクエリが必要な場合、`.memo/{dataset}/{table}.json` でテーブルスキーマを確認します。

**例:** `.memo/{source_name}/users.json`

### 3. SQLクエリの作成（必要に応じて）
`queries/{category}/` ディレクトリに新しい `.sql` ファイルを作成します。

**パス例:** `queries/new_dashboard/daily_metrics.sql`

```sql
-- クエリ定義
SELECT
  date,
  metric_name,
  metric_value
FROM dataset.table
WHERE date >= CURRENT_DATE() - 30
ORDER BY date DESC
```

### 4. データソースの確認
`sources/` 以下にある `connection.yaml` と `connection.options.yaml` でデータベース接続設定を確認します。

### 5. ページ内でクエリを参照
ページのマークダウン内でクエリを参照します。

```markdown
<DataTable data={daily_metrics} />
```

### 6. ビルド・確認
- ローカル環境で動作確認 `npm run sources` `npm run dev` で実行確認

## ファイル構成参考

```
pages/
  new-dashboard.md

queries/
  new_dashboard/
    daily_metrics.sql
    weekly_summary.sql

sources/
  xxxx/
    (既存接続を利用)
```

## 注記
- ページファイルは Evidence の Markdown形式に準拠
- クエリは sourceのconnection似合わせる
