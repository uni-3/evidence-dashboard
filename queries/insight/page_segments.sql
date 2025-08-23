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
        percentile_cont(impressions, 0.5) over() as median_impressions,
        percentile_cont(position, 0.5) over() as median_position,
        percentile_cont(ctr, 0.5) over() as median_ctr
    from page_metrics
)
select
    pm.page_title,
    pm.impressions,
    pm.position,
    pm.ctr,
    case
        when pm.impressions > (select median_impressions from medians limit 1) and pm.position < (select median_position from medians limit 1) and pm.ctr < (select median_ctr from medians limit 1) then 'Unseen Billboard'
        when pm.impressions < (select median_impressions from medians limit 1) and pm.ctr > (select median_ctr from medians limit 1) then 'Hidden Gem'
        when pm.position < 5 and pm.ctr < (select median_ctr from medians limit 1) then 'Unconvincing Winner'
        when pm.position > 10 and pm.ctr > (select median_ctr from medians limit 1) then 'Rising Star'
        else 'Other'
    end as segment
from page_metrics pm
