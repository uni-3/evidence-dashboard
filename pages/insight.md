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
    x=normalized_ctr
    y=normalized_impressions
    series=segment
    size=normalized_clicks
    yAxis=true
    yAxisLabels=true
    yGridlines=true
    xGridlines=true
    yFmt=num2
    xFmt=num2
    sizeFmt=num2
    xMin=0
    xMax=1
    yMin=0
    yMax=1
    yAxisTitle="Normalized Impressions"
    xAxisTitle="Normalized CTR"
    colorPalette={['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']}
    tooltipTitle=tooltip_title
>
</BubbleChart>

<!--
    Note on tooltip:
    The tooltip title is set to a custom column combining page_title and position.
    The tooltip body will show the values for x, y, and size by default.
    The raw values for ctr, impressions, and clicks are available in the dataset.
-->
