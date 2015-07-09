glob = require("glob")
path = require("path")

module.exports = (app)->
  {
    auth      : include("helpers/auth") app
    response  : include("helpers/response") app
    logger    : include("helpers/logger")
  }