require './globals'

express = require 'express'
bodyParser = require 'body-parser'
session = require 'express-session'
mustacheExpress = require 'mustache-express'

app = express()

app.session = session({
  secret: '85a08ee5-0028-4fac-8ae2-1ae6ef9489a3'
  resave: false
  saveUninitialized: true
})

app.config = include('config')
app.helpers = include('helpers') app
app.models = include('models')

app.engine 'html', mustacheExpress()
app.set 'view engine', 'html'

app.use express.static('static')
app.use app.helpers.response
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })
app.use app.helpers.logger.request

app.get '/', app.helpers.auth.session, (req, res, next)-> res.render('index')

include('routes') app

app.use (err, req, res, next)-> return res.serverError()
app.use app.helpers.logger.error

module.exports = app