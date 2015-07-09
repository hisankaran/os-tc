uuid = require 'uuid'
crypto = require 'crypto'

module.exports = (app)->

  app.get '/list1', app.helpers.auth.session, (req, res, next)->
    res.render('list')

  app.get '/list2', app.helpers.auth.session, (req, res, next)->
    res.render('list')

  app.get '/login', app.helpers.auth.session, (req, res, next)->
    res.render('login')

  app.post '/login', app.helpers.auth.session, (req, res, next)->
    if req.body.username and req.body.password
      app.models.user.findOne({where: {
        username: req.body.username
      }}).then((user)->
        if user and user.password is crypto.createHash('md5').update(req.body.password).digest("hex")
          req.session.token = uuid.v4()
          res.redirect(req.session.next_path or '/')
        else
          res.render('login', {error: 'Invalid username or password!'})
      ).catch((error)->
        console.error error
        res.render('login', {error: 'Something went wrong!'})
      )
    else
      res.render('login', {error: 'Username and Password is required!'})

  app.get '/logout', app.helpers.auth.session, (req, res, next)->
    req.session.destroy()
    res.redirect('/login')