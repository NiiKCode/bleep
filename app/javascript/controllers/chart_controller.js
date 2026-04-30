import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    console.log("✅ Chart controller connected")

    // ✅ Chart comes from global (UMD), NOT import
    const ctx = this.element.getContext("2d")

    const colors = ["#f97316", "#22c55e", "#3b82f6", "#eab308"]

    const datasets = Object.entries(this.dataValue).map(([label, points], i) => ({
      label: label,
      data: points,
      borderColor: colors[i % colors.length],
      backgroundColor: colors[i % colors.length],
      tension: 0.3,
      pointRadius: 3,
      spanGaps: true
    }))

    // ✅ dynamic time unit
    const maxPoints = Math.max(...datasets.map(d => d.data.length))

    new Chart(ctx, {
      type: "line",
      data: { datasets },
      options: {
        responsive: true,
        maintainAspectRatio: false,

        parsing: {
          xAxisKey: "x",
          yAxisKey: "y"
        },

        scales: {
          x: {
            type: "time",
            time: {
              unit:
                maxPoints > 200 ? "year" :
                maxPoints > 60  ? "month" :
                "day"
            }
          },
          y: {
            beginAtZero: true
          }
        },

        plugins: {
          decimation: {
            enabled: true,
            algorithm: "lttb"
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                return `${context.dataset.label}: ${context.parsed.y}`
              }
            }
          }
        }
      }
    })
  }
}
