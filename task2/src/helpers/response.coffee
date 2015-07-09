module.exports = (app)->

  # Response Shortcuts
  # Response format supported: json

  (req, res, next)->

      res.sendResponse = (obj)->
          if arguments.length is 2
              if typeof arguments[1] is "number"
                  res.statusCode = arguments[1]
              else
                  res.statusCode = obj
                  obj = arguments[1]

          res.header("Content-Type", "application/json")
          res.send(obj)

      res.badRequest = (message)->
          res.sendResponse(HTTP_STATUS_CODES.BAD_REQUEST, {
            status: false,
            error: {
              code: HTTP_STATUS_CODES.BAD_REQUEST,
              message: "Bad Request, " + (message || "required parameters missing or invalid")
            }
          })

      res.unAuthorized  = (message)->
          res.sendResponse(HTTP_STATUS_CODES.UNAUTHORIZED, {
            status: false,
            error: {
              code: HTTP_STATUS_CODES.UNAUTHORIZED,
              message: "Unauthorized, " + (message || "invalid authentication data")
            }
          })

      res.forbidden = (message)->
          res.sendResponse(HTTP_STATUS_CODES.FORBIDDEN, {
            status: false,
            error: {
              code: HTTP_STATUS_CODES.FORBIDDEN,
              message: "Forbidden, " + (message || "authentication required")
            }
          })

      res.notFound = (message)->
          res.sendResponse(HTTP_STATUS_CODES.NOT_FOUND, {
            status: false,
            error: {
              code: HTTP_STATUS_CODES.NOT_FOUND,
              message: "Not Found, " + (message || "requested resource not available")
            }
          })

      res.serverError = (message)->
          res.sendResponse(HTTP_STATUS_CODES.INTERNAL_SERVER_ERROR, {
            status: false,
            error: {
              code: HTTP_STATUS_CODES.INTERNAL_SERVER_ERROR,
              message: "Internal server error occured"
            }
          })

      next()