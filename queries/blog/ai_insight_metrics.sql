select insight
from free.ai_insights
where source_model = 'metrics'
order by month desc
limit 1
