---
title: Metrics
queries:
  - norm_metrics_month: blog/norm_metrics_month.sql
  - norm_pv_day_of_week: blog/norm_pv_day_of_week.sql
  - metrics_bubble_chart: blog/metrics_bubble_chart.sql
  - tag_pv_share: blog/tag_pv_share.sql
  - word_click_share: blog/word_click_share.sql
---

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




<LastRefreshed/>
