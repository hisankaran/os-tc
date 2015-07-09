path = require 'path'

global.HTTP_STATUS_CODES = require 'http-status-codes'

global._ = require 'lodash'

global.__projectdir = path.join "#{ __dirname }#{ path.sep }"

global.fullPath = (file)-> "#{__projectdir}#{file}"

global.include = (file)-> require "#{fullPath(file)}"