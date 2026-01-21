with
    -- 1. ページ(slug)ごとの月次PVを集計
    page_monthly_pv as (
        select
            date_trunc('month', d) as month_key,
            regexp_extract(page_location, 'blog\.uni-3\.app/([^/?#]+)', 1) as slug,
            sum(pv) as total_pv
        from free.metrics
        where page_location like '%blog.uni-3.app/%'
        group by 1, 2
    ),
    -- 2. タグ情報を結合して、タグごとのPVを算出
    tag_monthly_pv as (
        select
            m.month_key,
            t.tag,
            sum(m.total_pv) as tag_pv
        from page_monthly_pv m
        join free.page_tags t on m.slug = t.slug
        group by 1, 2
    ),
    -- 3. 各月のTop 10タグを特定
    ranked_tags as (
        select
            month_key,
            tag,
            tag_pv,
            row_number() over (partition by month_key order by tag_pv desc, tag asc) as tag_rank
        from tag_monthly_pv
    ),
    top_10_per_month as (
        select
            month_key,
            tag,
            tag_pv
        from ranked_tags
        where tag_rank <= 10
    ),
    -- 4. Top 10内でのPVシェア（構成比）を計算
    month_total as (
        select
            month_key as join_month,
            sum(tag_pv) as total_pv_sum
        from top_10_per_month
        group by 1
    )
select
    -- 日付型のまま返す（ソート順を保証するため）
    t.month_key as month,
    t.tag,
    -- 0-1の小数として算出
    t.tag_pv / nullif(m.total_pv_sum, 0) as pv_share
from top_10_per_month t
join month_total m on t.month_key = m.join_month
order by month asc, pv_share desc
