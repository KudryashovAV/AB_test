const path = require("path");
const tailwindcss = require("tailwindcss");

module.exports = {
  entryPoints: ["app/assets/javascript/application.js"],
  bundle: true,
  outfile: "app/assets/builds/application.js",
  plugins: [tailwindcss("app/assets/stylesheets/application.tailwind.css")],
};
