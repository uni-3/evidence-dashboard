with page_metrics as (
    select
        page_title,
        sum(impressions) as impressions,
        sum(clicks) as clicks,
        avg(avg_position) as position,
        CAST(sum(clicks) AS REAL) / NULLIF(sum(impressions), 0) as ctr
    from free.metrics
    group by page_title
),
medians as (
    select
        approx_quantile(impressions, 0.5) as median_impressions,
        approx_quantile(position, 0.5) as median_position,
        approx_quantile(ctr, 0.5) as median_ctr
    from page_metrics
)
select
    pm.page_title,
    CONCAT(pm.page_title, ' (順位: ', CAST(ROUND(pm.position, 1) AS STRING), ')') as tooltip_title,
    -- Raw values for tooltip and logic
    pm.impressions,
    pm.clicks,
    pm.position,
    pm.ctr,
    -- Normalized values for chart axes and size
    CAST(pm.ctr AS REAL) / NULLIF(max(pm.ctr) over (), 0) as normalized_ctr,
    CAST(pm.impressions AS REAL) / NULLIF(max(pm.impressions) over (), 0) as normalized_impressions,
    CAST(pm.clicks AS REAL) / NULLIF(max(pm.clicks) over (), 0) as normalized_clicks,
    -- Segmentation logic using raw values
    case
        when pm.impressions > COALESCE(m.median_impressions, 0) and pm.position < COALESCE(m.median_position, 999) and pm.ctr < COALESCE(m.median_ctr, 0) then '見えない看板'
        when pm.impressions < COALESCE(m.median_impressions, 0) and pm.ctr > COALESCE(m.median_ctr, 0) then '隠れた逸品'
        when pm.position < COALESCE(m.median_position, 999) and pm.ctr < COALESCE(m.median_ctr, 0) then '説得力のない勝者'
        when pm.position > COALESCE(m.median_position, 999) and pm.ctr > COALESCE(m.median_ctr, 0) then '期待の星'
        else 'その他'
    end as segment
from page_metrics pm
cross join medians m
