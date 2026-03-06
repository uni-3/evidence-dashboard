---
title: blog dashboard

queries:
  - content_len: blog/content_len.sql
  - content_count: blog/content_count.sql
  - content_total_count: blog/content_total_count.sql
  - tag_count: blog/tag_count.sql
  - rank_month: blog/rank_month.sql
  - search_word_network: blog/search_word_network.sql
  - ai_insight_rankings: blog/ai_insight_rankings.sql
---


### 記事に関するデータ

記事数合計: ** <Value data={content_total_count} column="c" /> **

<Grid cols=2>
  <Group>
    <LineChart
        data={content_count}
        x=year
        y=c
        labels=true
        markers=true
        yGridlines=false
        title="記事数推移"
    />
  </Group>

  <Histogram
      data={content_len}
      x=len_content
      title="記事の文字数分布"
      fillColor=#b8645e
  />
</Grid>

<BarChart
    data={tag_count}
    x=year
    y=count
    series=tag
    legend=false
    sort=false
    title="count by tag(appears 3 or more times)"
    echartsOptions={{ tooltip: { show: true, trigger: 'item', formatter: (params) => params.seriesName + ': ' + params.value[1] } }}
/>


<script>
    const SERIES_COUNT = 100; // 最悪ケース (10記事/月 × 6ヶ月 = 60) を想定し、余裕を持たせて100
    const rankChartOptions = {
        yAxis: { inverse: true, axisLabel: { show: false } },
        grid: { top: 60, left: 10 },
        tooltip: { show: true, trigger: 'item', formatter: '{a}' },
        labelLayout: { hideOverlap: false },
        series: Array.from({length: SERIES_COUNT}, () => ({
            symbolSize: 28,
            label: { show: true, position: 'inside', fontSize: 11, fontWeight: 'bold', color: '#fff' },
            emphasis: { label: { show: true, position: 'inside', fontSize: 11, fontWeight: 'bold', color: '#fff' } }
        }))
    };
</script>

<LineChart
    data={rank_month}
    x=month
    y=pv_rank
    yMin=1
    yMax=11
    markerSize=28
    yGridlines=false
    series=page_title
    step=true
    markers=true
    chartAreaHeight=350
    title="ページごとのPV数順位の推移"
    echartsOptions={rankChartOptions}
/>

{#if ai_insight_rankings.length > 0}
<Alert status="info">
  <b>ℹ️ AIによるサマリ</b><br/>
  {ai_insight_rankings[0].insight}
</Alert>
{/if}

<div class="p-6 rounded-xl shadow-sm border border-gray-100 my-8">
  <h4 class="text-md font-semibold text-gray-800 mb-1">検索単語の共起ネットワーク</h4>

  <div class="w-full" style="height: 400px; display: flex; flex-direction: column;">
    <NetworkGraph data={search_word_network} />
  </div>
</div>

<LastRefreshed/>
