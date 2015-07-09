util = require('util')
fs = require('fs-extra')
winston = require('winston')
expressWinston = require('express-winston')

loggers = {}
logBasePath = '/var/log/app/'

if process.env.NODE_ENV == 'development'
  loggers =
    request: expressWinston.logger(
      transports: [ new (winston.transports.Console)(
        json: true
        colorize: true) ]
      meta: true
      msg: 'HTTP {{req.method}} {{req.url}}'
      expressFormat: true)
    error: expressWinston.errorLogger(
      transports: [ new (winston.transports.Console)(
        json: true
        handleExceptions: true) ]
      exitOnError: false)
    console: new (winston.Logger)(transports: [ new (winston.transports.Console)(
      timestamp: true
      showLevel: true) ])
else
  fs.ensureDir(logBasePath)
  loggers =
    request: expressWinston.logger(
      transports: [ new (winston.transports.File)(
        filename: logBasePath + 'stdout.log'
        showLevel: true
        tailable: true) ]
      meta: true
      msg: 'HTTP {{req.method}} {{req.url}}'
      expressFormat: true)
    error: expressWinston.errorLogger(
      transports: [ new (winston.transports.File)(
        filename: logBasePath + 'stderr.log'
        showLevel: true
        tailable: true
        json: false
        handleExceptions: true) ]
      exitOnError: false)
    console: new (winston.Logger)(transports: [ new (winston.transports.File)(
      filename: logBasePath + 'stdout.log'
      showLevel: true
      tailable: true
      json: false) ])

formatArgs = (args) ->
  [ util.format.apply(util.format, Array::slice.call(args)) ]

console.log = ->
  loggers.console.info.apply loggers.console.info, formatArgs(arguments)
  return

console.info = ->
  loggers.console.info.apply loggers.console.info, formatArgs(arguments)
  return

console.warn = ->
  loggers.console.warn.apply loggers.console.warn, formatArgs(arguments)
  return

console.error = ->
  loggers.console.error.apply loggers.console.error, formatArgs(arguments)
  return

console.debug = ->
  loggers.console.debug.apply loggers.console.debug, formatArgs(arguments)
  return

module.exports = loggers