select
    *,
    concat(left(page_title, 10), '...') as page_title_offset
from free.monthly_rankings
where pv_rank <= 10
order by month, pv_rank
