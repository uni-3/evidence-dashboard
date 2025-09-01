---
title: Page Insight
queries:
  - segments: insight/page_segments.sql
---

# Page Segmentation

This chart classifies pages into segments based on their performance in Google Search.

### セグメントの定義

-   **主力 (Mainstay)**: CTRと掲載順位が共に中央値より良いページ
-   **期待の星 (Rising Star)**: CTRは高いが、掲載順位がまだ低いページ
-   **説得力のない勝者 (Unconvincing Winner)**: 掲載順位は良いが、CTRが低いページ
-   **隠れた逸品 (Hidden Gem)**: インプレッションは低いが、CTRが高い特別なページ
-   **その他 (Other)**: CTRと掲載順位が共に中央値より悪いページ


<ScatterPlot
    data={segments}
    title="Page Segments"
    x=normalized_ctr
    y=normalized_impressions
    series=segment
    yAxis=true
    yAxisLabels=true
    yGridlines=true
    xGridlines=true
    yFmt=num2
    xFmt=num2
    xMin=0
    xMax=1
    yMin=0
    yMax=1
    yAxisTitle="Normalized Impressions"
    xAxisTitle="Normalized CTR"
    colorPalette={['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd']}
    tooltipTitle=tooltip_title
>
</ScatterPlot>

<!--
    Note on tooltip:
    The tooltip title is set to a custom column combining page_title and position.
    The tooltip body will show the values for x and y by default.
    The raw values for ctr, impressions, and clicks are available in the dataset.
-->
