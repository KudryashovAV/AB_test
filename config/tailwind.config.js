const defaultTheme = require("tailwindcss/defaultTheme")

module.exports = {
  content: [
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,html}",
  ],
  theme: {
    extend: {}
  },
  variants: {
    extend: {},
  },
  paths: {
    styles: ["app/assets/stylesheets/application.tailwind.css"],
    output: "app/assets/builds",
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries')
  ]
}
