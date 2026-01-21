with word_pages as (
    select distinct
        url,
        split_part(query_word, ' ', 1) as word
    from free.count_search_word
    where clicks > 0
),
pairs as (
    select
        a.word as source,
        b.word as target,
        count(*) as weight
    from word_pages a
    join word_pages b on a.url = b.url and a.word < b.word
    group by 1, 2
    having weight >= 1
),
word_counts as (
    select
        split_part(query_word, ' ', 1) as word,
        sum(clicks) as clicks
    from free.count_search_word
    group by 1
)
select
    p.source,
    p.target,
    p.weight,
    s.clicks as source_clicks,
    t.clicks as target_clicks
from pairs p
join word_counts s on p.source = s.word
join word_counts t on p.target = t.word
order by p.weight desc
limit 200
