export default {
  content: [
    "./app/views/**/*.{erb,html}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {
      fontFamily: {
        futura: ["FuturaPT", "sans-serif"],
        "futura-condensed": ["FuturaPT Condensed", "sans-serif"],
      },
    },
  },
  plugins: [],
}
