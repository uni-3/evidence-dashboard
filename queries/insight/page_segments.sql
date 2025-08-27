with page_metrics as (
    select
        page_title,
        sum(impressions) as impressions,
        avg(avg_position) as position,
        fdiv(sum(clicks), sum(impressions)) as ctr
    from free.metrics
    group by page_title
),
medians as (
    select
        approx_quantiles(impressions, 2)[2] as median_impressions,
        approx_quantiles(position, 2)[2] as median_position,
        approx_quantiles(ctr, 2)[2] as median_ctr
    from page_metrics
)
select
    pm.page_title,
    pm.impressions,
    pm.position,
    pm.ctr,
    case
        when pm.impressions > COALESCE(m.median_impressions, 0) and pm.position < COALESCE(m.median_position, 999) and pm.ctr < COALESCE(m.median_ctr, 0) then 'Unseen Billboard'
        when pm.impressions < COALESCE(m.median_impressions, 0) and pm.ctr > COALESCE(m.median_ctr, 0) then 'Hidden Gem'
        when pm.position < 5 and pm.ctr < COALESCE(m.median_ctr, 0) then 'Unconvincing Winner'
        when pm.position > 10 and pm.ctr > COALESCE(m.median_ctr, 0) then 'Rising Star'
        else 'Other'
    end as segment
from page_metrics pm
cross join medians m
