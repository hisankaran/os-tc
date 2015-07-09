crypto = require 'crypto'

module.exports = (app)->

  #
  # Authentication middleware for authenticating the API calls.
  #
  # @header   AuthToken [required]
  # @returns  HTTP_FORBIDDEN    - If the header not found in the request
  #           HTTP_UNAUTHORIZED - If the provided token is invalid
  #
  api: (req, res, next)->
    if req.path.replace(/\W/g, '')
      auth_token = req.headers.authtoken or null
      if not auth_token
          return res.forbidden()
      else
        app.models.user.findOne({where: {
          auth_token: auth_token
        }}).then((user)->
          if user
            req.user = user
            next()
          else res.unAuthorized()
        ).catch((error)->
          console.error error
          res.serverError()
        )

  session: (req, res, next)->
    app.session(req, res, ()->
      login_path = '/login'
      is_login_page = req.path is login_path
      if req.session.token
        if not is_login_page then next()
        else
          res.redirect('/')
      else if not is_login_page
        req.session.next_path = req.path
        req.session.save(()->
          res.redirect(login_path)
        )
      else
        next()
    )
