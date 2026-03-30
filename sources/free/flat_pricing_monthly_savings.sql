select
  format_date('%Y-%m', end_time) as month,
  sum(cost_savings) as total_cost_savings
from
  blog_info_dbt_bigquery_monitoring.query_with_better_pricing_using_flat_pricing_view
where
  cost_savings is not null
  and end_time is not null
group by
  month
order by
  month asc
