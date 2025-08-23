with page_metrics as (
    select
        page_title,
        sum(impressions) as impressions,
        avg(position) as position,
        safe_divide(sum(clicks), sum(impressions)) as ctr
    from free.metrics
    group by page_title
),
medians as (
    select
        approx_quantiles(impressions, 2)[offset(1)] as median_impressions,
        approx_quantiles(position, 2)[offset(1)] as median_position,
        approx_quantiles(ctr, 2)[offset(1)] as median_ctr
    from page_metrics
)
select
    pm.page_title,
    pm.impressions,
    pm.position,
    pm.ctr,
    case
        when pm.impressions > m.median_impressions and pm.position < m.median_position and pm.ctr < m.median_ctr then 'Unseen Billboard'
        when pm.impressions < m.median_impressions and pm.ctr > m.median_ctr then 'Hidden Gem'
        when pm.position < 5 and pm.ctr < m.median_ctr then 'Unconvincing Winner'
        when pm.position > 10 and pm.ctr > m.median_ctr then 'Rising Star'
        else 'Other'
    end as segment
from page_metrics pm
cross join medians m
