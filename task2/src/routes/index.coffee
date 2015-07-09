glob = require('glob')
path = require('path')

module.exports = (app)->

  app.param 'noteId', (req, res, next, id)->
    where = {id: id}
    app.models.note.find({where: where}).then((note)->
      if note is null then return res.badRequest('Entry not found')
      req.note = note
      next()
    )

  # include all other route definitions
  glob '**/*.js', {cwd: __dirname}, (err, files)->
    if err
      console.error 'Unable to load route files'
    else
      _.without(files, path.basename(__filename)).forEach (file)->
        console.log "Loading route definition: #{ file }"
        include("routes/#{ file }") app