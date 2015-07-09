app = require './app'

app.listen(app.config.port, ()->
  console.log "Server started and listening on port #{ app.config.port }"
)