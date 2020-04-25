const path = require('path');
const elmloader = require('./webpack.elmloader.js');

process.env.BABEL_ENV = 'production';
process.env.NODE_ENV = 'production';

module.exports = {
  mode: 'production',
  entry: './src/App.jsx',
  output: {
    path: path.resolve(__dirname, 'lib'),
    filename: 'HomeremoteStreamPlayer.js',
    libraryTarget: 'commonjs2'
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        include: path.resolve(__dirname, 'src'),
        exclude: /(node_modules|bower_components|build)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env', '@babel/preset-react']
          }
        }
      },
      { test: /\.css$/, loader: "style-loader!css-loader" },
      { test: /\.svg$/, loader: "url-loader" },
      // loader for elm files
      elmloader
    ]
  },
  externals: {
    'react': 'commonjs react'
  }
};
