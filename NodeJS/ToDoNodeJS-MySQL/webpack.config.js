const path = require("path");

module.exports = {
  entry: "./app.js",
  output: {
    filename: `bundle.js`,
  },
  target: "node",
  mode: "production",
};