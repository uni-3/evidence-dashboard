with
    words_processed as (
        select
            split_part(query_word, ' ', 1) as word,
            clicks
        from free.count_search_word
        where clicks > 0
    ),
    word_clicks as (
        select
            word as query_word,
            sum(clicks) as total_clicks
        from words_processed
        group by 1
    ),
    top_10 as (
        select
            query_word,
            total_clicks
        from word_clicks
        order by total_clicks desc
        limit 10
    ),
    top_10_total as (
        select sum(total_clicks) as grand_total from top_10
    )
select
    'Word' as category,
    query_word,
    -- 0-1の小数として算出
    total_clicks / nullif(grand_total, 0) as click_share
from top_10, top_10_total
order by click_share desc
