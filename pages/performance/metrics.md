---
title: Metrics
queries:
  - norm_metrics_month: blog/norm_metrics_month.sql
  - norm_pv_day_of_week: blog/norm_pv_day_of_week.sql
  - metrics_bubble_chart: blog/metrics_bubble_chart.sql
  - tag_pv_share: blog/tag_pv_share.sql
  - word_click_share: blog/word_click_share.sql
  - ai_insight_metrics: blog/ai_insight_metrics.sql
---

### 全体指標に関するチャート

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

{#if ai_insight_metrics.length > 0}
<Alert status="info">
  <b>ℹ️ AIによるサマリ</b><br/>
  {ai_insight_metrics[0].insight}
</Alert>
{/if}


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

### ページ・タグなど個別の指標に関するチャート

<BubbleChart
    title="記事ごとのPV/CTRの分布"
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
    x=query_word
    y=click_share
    title="検索単語のクリック貢献シェア (上位10)"
    swapXY=true
    yFmt=pct2
    sort=true
    yAxisTitle="検索単語"
    xAxisTitle=false
    xAxis=false
    xGridlines=false
    tooltipTitle="query_word"
    labels=true
    echartsOptions={{
        grid: {
            left: 20,
            containLabel: true
        },
        xAxis: {
            show: false
        },
        yAxis: {
            axisLabel: {
                interval: 0,
                formatter: (value) => {
                    let text = value.length > 50 ? value.substring(0, 50) + '...' : value;
                    let result = '';
                    while (text.length > 20) {
                        let i = text.substring(0, 20).lastIndexOf(' ');
                        i = i === -1 ? 20 : i; // 20文字以内にスペースが無ければ強制的に20文字で切る
                        result += text.substring(0, i) + '\n';
                        text = text.substring(i + (text[i] === ' ' ? 1 : 0));
                    }
                    return result + text;
                }
            }
        }
    }}
/>

<LastRefreshed/>
