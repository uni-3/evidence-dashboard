select
    slug,
    tag
from blog_info_staging.stg_blog_info__blog_content
cross join unnest(tags) as tag
