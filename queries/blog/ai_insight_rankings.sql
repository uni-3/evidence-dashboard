select insight
from free.ai_insights
where source_model = 'monthly_rankings'
order by month desc
limit 1
