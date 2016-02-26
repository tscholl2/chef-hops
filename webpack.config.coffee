require 'coffee-script/register'

webpack = require 'webpack'
path = require 'path'

module.exports =
  # file to start the bundle process
  entry: [
      './src/main.coffee'
  ]
  # output file/directory
  output:
    # path of the bundled file
    path: './lib'
    # name of the bundle file
    filename: 'bundle.js'
    # path served relative to directory
    publicPath: 'lib/'
  module:
    # loaders define how to deal with files
    loaders: [
      {test: /\.coffee$/, loaders: ['coffee']}
    ]
  resolve:
    # root is the root of the web directory
    root: '/'
    # modules are where webpack looks for directories
    # so if you require 'utils/localstorage' then it looks
    # around for these folders until it finds one, and looks
    # in it for a file called `localstorage`
    # basically in src/components/pages/Problem/index.coffee
    # you can require 'src/actions/API' and get the API actions
    modulesDirectories: ['node_modules','hamweb']
    # these are shortcuts so you can `require('main')` instead of `require('main.js')`
    extensions: ['', '.js', '.coffee']
  plugins: [
    # allows hot reloading in dev server
    new webpack.HotModuleReplacementPlugin()
    new webpack.DefinePlugin
      'process.env': {'NODE_ENV': JSON.stringify('development')}
    new webpack.optimize.UglifyJsPlugin
      compress: true
  ]
  # see http://webpack.github.io/docs/configuration.html#devtool
  # for all the crazy options for `devtools` field
  devtool: 'eval'
  # for running webpack-dev-server
  devServer:
    noInfo: false  # displays things like size of bundle
    colors: true # shows colored output on console
    hot: true # do NOT use --hot on command line with react-hotreload
    inline: true # don't have to add extra script tag on index
    port: 8080
    host: "0.0.0.0" # set to 0.0.0.0 to allow others to see
    contentBase: '.' # directory files are served from (really its from memory)
