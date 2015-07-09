uuid = require 'uuid'
crypto = require 'crypto'

module.exports = (app)->

  #
  # Create a new user.
  #
  # @params   first_name [optional|empty]
  # @params   last_name [optional|empty]
  # @params   email [required]
  # @params   username [required]
  # @params   password [required]
  #
  # @returns  successful call returns HTTP_CREATED (201) with auth_token
  #
  app.post '/user', (req, res, next)->
    if req.body.email and req.body.username and req.body.password
      app.models.user.create({
        first_name: req.body.first_name or ''
        last_name: req.body.last_name or ''
        email: req.body.email
        username: req.body.username
        password: req.body.password
        auth_token: uuid.v4()
      }).then((user)->
        res.sendResponse(HTTP_STATUS_CODES.CREATED, {
          status: true
          data: {
            auth_token: user.auth_token
          }
        })
      ).catch((error)->
        console.error error
        if error.name is 'SequelizeUniqueConstraintError' then res.badRequest('Username is already taken')
        else res.serverError()
      )
    else
      res.badRequest()

  #
  # Login as a user and create Auth Token.
  #
  # @params   username [required]
  # @params   password [required]
  #
  # @returns  successful call returns HTTP_OK (200) with auth_token
  #
  app.post '/user/login', (req, res, next)->
    if req.body.username and req.body.password
      app.models.user.findOne({where: {
        username: req.body.username
      }}).then((user)->
        if user and user.password is crypto.createHash('md5').update(req.body.password).digest("hex")
          user.auth_token = uuid.v4()
          user.save()
          res.sendResponse(HTTP_STATUS_CODES.OK, {
            status: true
            data: {
              auth_token: user.auth_token
            }
          })
        else
          res.badRequest('Invalid username or password')
      ).catch((error)->
        console.error error
        res.serverError()
      )
    else
      res.badRequest()

  #
  # Retrieve the logged-in user info
  #
  # @header   AuthToken [required]
  # @returns  successful call returns HTTP_OK (200) with user info
  #
  app.get '/user/info', app.helpers.auth.api, (req, res, next)->
    res.sendResponse(HTTP_STATUS_CODES.OK, {
      status: true
      data: {
        id: req.user.id
        first_name: req.user.first_name
        last_name: req.user.last_name
        email: req.user.email
        username: req.user.username
      }
    })

  #
  # Logout a user form the system and invalidate their Auth Token.
  #
  # @header   AuthToken [required]
  # @returns  successful call returns HTTP_OK (200)
  #
  app.post '/user/logout', app.helpers.auth.api, (req, res, next)->
    req.user.auth_token = null
    req.user.save()
    res.sendResponse(HTTP_STATUS_CODES.OK, {
      status: true
    })

  #
  # Delete the authenticated user's account
  #
  # @header   AuthToken [required]
  # @returns  successful call returns HTTP_OK (200)
  #
  app.delete '/user', app.helpers.auth.api, (req, res, next)->
    req.user.destroy().then(()->
      res.sendResponse(HTTP_STATUS_CODES.OK, {
        status: true
      })
    )