-- sources/kufu_data/dataset_cost.sql
SELECT
  project_id,
  dataset_id,
  storage_last_modified_time,
  total_rows,
  physical_cost_monthly_forecast AS monthly_forecast_storage_cost,
  -- 仮レート
  physical_cost_monthly_forecast * 150 AS monthly_forecast_storage_cost_jpy
FROM
  blog_info_dbt_bigquery_monitoring.dataset_with_cost
