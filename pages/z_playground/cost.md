---
title: cost
sidebar_link: false
queries:
  - daily_spend: dbt_bigquery_monitoring/daily_spend.sql
  - dataset_storage_cost: dbt_bigquery_monitoring/dataset_cost.sql # データセット別ストレージ情報
  - flat_pricing_monthly_savings: dbt_bigquery_monitoring/flat_pricing_monthly_savings.sql
---

## コスト

### クエリコスト推移

<LineChart
    data={daily_spend}
    x=spend_date
    y=cost_jpy
    title="日別 BigQuery クエリコスト推移"
    xAxisTitle="日付"
    yAxisTitle="コスト (JPY)"
/>

### データセット別ストレージコスト

{#if dataset_storage_cost.length > 0}

<DataTable
    data={dataset_storage_cost}
    title="データセット別 ストレージコスト"
    subtitle="各データセットの最新ストレージ情報（物理バイトベース）と月次予測コスト"
    rows=10
>
    <Column id=project_id title="Project ID" />
    <Column id=dataset_id title="Dataset ID" />
    <Column id=storage_last_modified_time title="最終更新日時" format=datetime />
    <Column id=monthly_forecast_storage_cost_jpy title="月次予測コスト (JPY)" format=jpy contentType=bar barColor=#ffe08a />
    <Column id=monthly_forecast_storage_cost title="月次予測コスト (USD)" format=usd />
    <Column id=total_rows title="総行数" format=number />
</DataTable>

{/if}

## コスト予測

### フラットプライシング適用時の月額コスト節約予測

<LineChart
    data={flat_pricing_monthly_savings}
    x=month
    y=total_cost_savings
    sort=asc
    title="月額コスト減少（フラットプライシング適用時）"
    xAxisTitle="月"
    yAxisTitle="コスト（USD）"
/>

<LastRefreshed/>
