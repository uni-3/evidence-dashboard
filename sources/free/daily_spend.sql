-- queries/dbt_bigquery_monitoring/daily_spend.sql
select
    cast(day as date) as spend_date,
    cost,
    cost * 150 as cost_jpy
from blog_info_dbt_bigquery_monitoring.daily_spend
order by spend_date asc -- 日付順にソート
