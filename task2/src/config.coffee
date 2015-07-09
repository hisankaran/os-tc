###
Environment Specific Configuration
==================================
Development : ./config/development.json
Staging     : ./config/staging.json
Production  : ./config/production.json
All the configuration files are git ignored, when ever you do configuration change, please update in template.json
###

module.exports = require("#{ __projectdir }../config/#{ process.env.NODE_ENV || 'development' }")