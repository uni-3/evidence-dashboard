---
title: Page Insight
queries:
  - segments: insight/page_segments.sql
---

# Page Segmentation

This chart classifies pages into segments based on their performance in Google Search.

<div style="border: 1px solid black; padding: 10px;">
<BubbleChart
    data={segments}
    title="Page Segments"
    x=ctr
    y=impressions
    series=segment
    size=clicks
    yMax=p95_impressions
    yFmt=num
    xFmt=num
    sizeFmt=num
    yAxisTitle="Impressions"
    xAxisTitle="Click Through Rate (0-100)"
    colorPalette={['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']}
>
</BubbleChart>
</div>
