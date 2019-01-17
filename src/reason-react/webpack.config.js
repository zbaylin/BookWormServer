const path = require('path');
const outputDir = path.join(__dirname, "build/");

const isProd = process.env.NODE_ENV === 'production';

module.exports = {
  entry: {
    Index: './lib/js/src/Index.bs.js',
    Redeem: './lib/js/src/Redeem.bs.js'
  },
  mode: isProd ? 'production' : 'development',
  output: {
    path: outputDir,
    publicPath: outputDir,
    filename: '[name].js',
  },
};
