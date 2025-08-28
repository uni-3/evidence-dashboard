---
title: Page Insight
queries:
  - segments: insight/page_segments.sql
---

# Page Segmentation

This chart classifies pages into segments based on their performance in Google Search.

<BubbleChart
    data={segments}
    title="Page Segments"
    x=ctr
    y=impressions
    series=segment
    size=clicks
    yMax=p95_impressions
    yGridlines=true
    xGridlines=true
    yFmt=num
    xFmt=num2
    xMin=0
    xMax=1
    sizeFmt=num
    yAxisTitle="Impressions"
    xAxisTitle="Click Through Rate"
    colorPalette={['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']}
    chartAreaHeight=450
    tooltipTitle=tooltip_title
    leftPadding=30
>
</BubbleChart>

<!--
    Note on tooltip:
    The tooltip title is set to a custom column combining page_title and position.
    The tooltip body will show the values for x (CTR), y (Impressions), and size (Clicks) by default.
-->
