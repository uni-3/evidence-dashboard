---
title: blog dashboard

queries:
  - content_len: blog/content_len.sql
  - content_count: blog/content_count.sql
  - content_total_count: blog/content_total_count.sql
  - rank_month: blog/rank_month.sql
  - tag_count: blog/tag_count.sql
  - norm_metrics_month: blog/norm_metrics_month.sql
  - norm_pv_day_of_week: blog/norm_pv_day_of_week.sql
  - metrics_bubble_chart: blog/metrics_bubble_chart.sql
  - tag_pv_share: blog/tag_pv_share.sql
  - word_click_share: blog/word_click_share.sql
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


### 指標に関するデータ

<BubbleChart
    title="記事ごとの指標"
    data={metrics_bubble_chart}
    x=ctr
    y=normalized_pv
    xFmt=num2
    yFmt=num2
    sizeFmt=num2
    yGridlines=false
    yMax=1.0
    yMin=0
    series=page_title
    size=normalized_imp
>
</BubbleChart>

<LineChart
    data={norm_metrics_month}
    x=month
    y=normalized_imp
    yMax=1
    markers=true
    title="最大を1としたときのimpression数の推移"
    labels=true
/>

<LineChart
    data={norm_metrics_month}
    x=month
    y=normalized_pv
    yMax=1
    markers=true
    title="最大を1としたときのPV数の推移"
    labels=true
/>


<BarChart
    data={norm_pv_day_of_week}
    x=day_of_week
    y=normalized_pv
    yMax=1
    labels=true
    yGridlines=false
    title="最大を1としたときの曜日別PV数"
    sort=false
/>

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


<BarChart
    data={tag_pv_share}
    x=month
    y=pv_share
    series=tag
    title="各月別Top 10タグのPVシェア"
    yFmt=pct2
    stack=true
    yMax=1
    echartsOptions={{
        tooltip: {
            trigger: 'item',
            formatter: (params) => {
                const val = params.value[params.seriesName] || params.value[1];
                return params.seriesName + ': ' + (Number(val) * 100).toFixed(2) + '%';
            }
        },
        xAxis: {
            axisLabel: {
                formatter: (value) => {
                    const d = new Date(value);
                    return d.getFullYear() + '/' + (d.getMonth() + 1).toString().padStart(2, '0');
                }
            }
        }
    }}
/>


<BarChart
    data={word_click_share}
    x=category
    y=click_share
    series=query_word
    stack=true
    title="検索単語のクリック貢献シェア (上位10単語)"
    yFmt=pct2
    swapXY=true
    xAxisTitle=false
    echartsOptions={{
        tooltip: {
            trigger: 'item',
            formatter: (params) => {
                const val = params.value[params.seriesName] || params.value[0];
                return params.seriesName + ': ' + (Number(val) * 100).toFixed(2) + '%';
            }
        },
        xAxis: { show: true },
        yAxis: { show: true},
    }}
/>


{#if search_word_network.length > 0}
<div class="p-6 rounded-xl shadow-sm border border-gray-100 my-8">
  <h4 class="text-md font-semibold text-gray-800 mb-1">検索単語の共起ネットワーク。クリック数1以上の検索のみ</h4>

  <div class="w-full" style="height: 350px; display: flex; flex-direction: column;">
    <ECharts
        config={{
            grid: {
                top: 20,
                right: 20,
                bottom: 20,
                left: 20,
                containLabel: true
            },
            tooltip: {
                trigger: 'item',
                formatter: (params) => {
                    if (params.dataType === 'edge') {
                        return `${params.data.source} - ${params.data.target}<br/>共起回数: ${params.data.value}`;
                    }
                    return params.name;
                }
            },
            series: [
                {
                    type: 'graph',
                    layout: 'force',
                    roam: true,
                    top: '5%',
                    bottom: '5%',
                    left: '5%',
                    right: '5%',
                    label: {
                        show: true,
                        position: 'right',
                        fontSize: 10,
                        color: '#4b5563'
                    },
                    force: {
                        repulsion: 300,
                        edgeLength: [50, 100],
                        gravity: 0.1
                    },
                    lineStyle: {
                        color: '#e5e7eb',
                        curveness: 0.4
                    },
                    emphasis: {
                        focus: 'adjacency',
                        lineStyle: {
                            width: 3,
                            color: '#3b82f6'
                        }
                    },
                    data: [
                        ...new Map(
                          [
                            ...search_word_network.map(d => [d.source, { name: d.source, value: d.source_clicks }]),
                            ...search_word_network.map(d => [d.target, { name: d.target, value: d.target_clicks }])
                          ]
                        ).values()
                    ].map(node => ({
                        ...node,
                        symbolSize: Math.sqrt(node.value || 1) * 3 + 8,
                        itemStyle: {
                            color: `hsl(${(node.value * 137) % 360}, 65%, 65%)`,
                            shadowBlur: 10,
                            shadowColor: 'rgba(0,0,0,0.05)'
                        }
                    })),
                    links: search_word_network.map(d => ({
                        source: d.source,
                        target: d.target,
                        value: d.weight,
                        lineStyle: {
                            width: Math.sqrt(d.weight) * 1.5,
                            opacity: 0.6
                        }
                    }))
                }
            ]
        }}
    />
  </div>
</div>
{:else}
  <div class="p-4 bg-blue-50 border border-blue-100 rounded-lg text-blue-700 text-sm my-8">
    共起ネットワークデータがありません
  </div>
{/if}

<LastRefreshed/>
