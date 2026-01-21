select
    cast(year as string) as year,
    tag,
    count
from free.tag_count
where count >= 3
order by year asc
