<script>
  import { ECharts } from "@evidence-dev/core-components";

  export let data = [];
</script>

{#if data.length > 0}
  <ECharts
    config={{
      grid: {
        top: 20,
        right: 20,
        bottom: 20,
        left: 20,
        containLabel: true,
      },
      tooltip: {
        trigger: "item",
        formatter: (params) => {
          if (params.dataType === "edge") {
            return `${params.data.source} - ${params.data.target}<br/>共起回数: ${params.data.value}`;
          }
          return params.name;
        },
      },
      series: [
        {
          type: "graph",
          layout: "force",
          roam: true,
          top: "5%",
          bottom: "5%",
          left: "5%",
          right: "5%",
          label: {
            show: true,
            position: "right",
            fontSize: 10,
            color: "#4b5563",
          },
          force: {
            repulsion: 300,
            edgeLength: [50, 100],
            gravity: 0.1,
          },
          lineStyle: {
            color: "#e5e7eb",
            curveness: 0.4,
          },
          emphasis: {
            focus: "adjacency",
            lineStyle: {
              width: 3,
              color: "#3b82f6",
            },
          },
          data: [
            ...new Map([
              ...data.map((d) => [d.source, { name: d.source, value: d.source_clicks }]),
              ...data.map((d) => [d.target, { name: d.target, value: d.target_clicks }]),
            ]).values(),
          ].map((node) => ({
            ...node,
            symbolSize: Math.sqrt(node.value || 1) * 3 + 8,
            itemStyle: {
              color: `hsl(${(node.value * 137) % 360}, 65%, 65%)`,
              shadowBlur: 10,
              shadowColor: "rgba(0,0,0,0.05)",
            },
          })),
          links: data.map((d) => ({
            source: d.source,
            target: d.target,
            value: d.weight,
            lineStyle: {
              width: Math.sqrt(d.weight) * 1.5,
              opacity: 0.6,
            },
          })),
        },
      ],
    }}
  />
{:else}
  <div class="flex items-center justify-center h-full text-gray-400 italic">共起ネットワークデータがありません</div>
{/if}
