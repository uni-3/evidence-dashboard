with page_metrics as (
    select
        page_title,
        sum(impressions) as impressions,
        sum(clicks) as clicks,
        avg(avg_position) as position,
        (CAST(sum(clicks) AS REAL) / NULLIF(sum(impressions), 0)) * 100 as ctr
    from free.metrics
    group by page_title
),
medians as (
    select
        approx_quantile(impressions, 0.5) as median_impressions,
        approx_quantile(impressions, 0.95) as p95_impressions,
        approx_quantile(position, 0.5) as median_position,
        approx_quantile(ctr, 0.5) as median_ctr
    from page_metrics
)
select
    pm.page_title,
    pm.impressions,
    pm.clicks,
    pm.position,
    pm.ctr,
    m.p95_impressions,
    case
        when pm.impressions > COALESCE(m.median_impressions, 0) and pm.position < COALESCE(m.median_position, 999) and pm.ctr < COALESCE(m.median_ctr, 0) then '見えない看板'
        when pm.impressions < COALESCE(m.median_impressions, 0) and pm.ctr > COALESCE(m.median_ctr, 0) then '隠れた逸品'
        when pm.position < COALESCE(m.median_position, 999) and pm.ctr < COALESCE(m.median_ctr, 0) then '説得力のない勝者'
        when pm.position > COALESCE(m.median_position, 999) and pm.ctr > COALESCE(m.median_ctr, 0) then '期待の星'
        else 'その他'
    end as segment
from page_metrics pm
cross join medians m
