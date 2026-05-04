export default {
  content: [
    "./app/views/**/*",
    "./app/helpers/**/*.rb",
    "./app/components/**/*",
    "./app/javascript/**/*",
    "./config/initializers/**/*.rb"
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
