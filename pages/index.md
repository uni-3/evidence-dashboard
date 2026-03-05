---
title: blog dashboard

queries:
  - content_len: blog/content_len.sql
  - content_count: blog/content_count.sql
  - content_total_count: blog/content_total_count.sql
  - tag_count: blog/tag_count.sql
  - rank_month: blog/rank_month.sql
  - search_word_network: blog/search_word_network.sql
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

  <BarChart
      data={tag_count}
      x=year
      y=count
      series=tag
      legend=false
      sort=false
      title="count by tag(appears 3 or more times)"
  />
</Grid>

<LineChart
    data={rank_month}
    x=month
    y=pv_rank
    yMin=1
    yMax=10
    markerSize=12
    yGridlines=false
    series=page_title
    step=true
    markers=true
    title="ページごとのPV数順位の推移"
    echartsOptions={{ yAxis: {inverse: true }, tooltip: { show: true, trigger: 'item', formatter: '{a}' }}}
/>

<div class="p-6 rounded-xl shadow-sm border border-gray-100 my-8">
  <h4 class="text-md font-semibold text-gray-800 mb-1">検索単語の共起ネットワーク。クリック数1以上の検索のみ</h4>

  <div class="w-full" style="height: 350px; display: flex; flex-direction: column;">
    <NetworkGraph data={search_word_network} />
  </div>
</div>

<LastRefreshed/>
