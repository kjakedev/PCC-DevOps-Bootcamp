const path = require('path');

module.exports = {
  mode: 'development', // Change to 'production' for deployment
  entry: './src/app.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'public')
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.handlebars$/,
        loader: 'handlebars-loader'
      }
    ]
  }
};
