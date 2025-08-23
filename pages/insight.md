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
    y=position
    series=segment
    size=impressions
    yFmt=num
    xFmt=pct
    sizeFmt=num
    yGridlines=false
    yAxisTitle="Average Position"
    xAxisTitle="Click Through Rate (CTR)"
>
</BubbleChart>
