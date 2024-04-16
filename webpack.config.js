const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin')
const ZipPlugin = require('zip-webpack-plugin');

module.exports = {
  entry: './src/index.js',
  output: {
    publicPath: './',
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },

  target: 'node',
  mode: 'development',

  resolve: {
    extensions: ['.js']
  },
  externals: {
    '@brightsign/deviceinfo': 'commonjs @brightsign/deviceinfo',
    '@brightsign/messageport': 'commonjs @brightsign/messageport',
    '@brightsign/networkconfiguration': 'commonjs @brightsign/networkconfiguration',
    '@brightsign/networkstatus': 'commonjs @brightsign/networkstatus'
  },
  module: {
    rules: [{}]
  },
  plugins: [
    // new CopyWebpackPlugin({
    //   patterns: [{
    //     from: './images',
    //     to: './images'
    //   },{
    //     from: './index.html',
    //     to: '.'
    //   },{
    //     from: './styles.css',
    //     to: '.'
    //   }
    // ]
    // }),
    // new ZipPlugin({
    //   filename: 'pluginNodeApp.zip'
    // })
  ]
};
