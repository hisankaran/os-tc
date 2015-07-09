fs = require('fs')

module.exports = (grunt) ->

  for key of grunt.file.readJSON('package.json').devDependencies
    if key isnt 'grunt' and key.indexOf('grunt') is 0
      grunt.loadNpmTasks key

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    mochaTest:
      test:
        src: ['test/**/*.coffee']
        options:
          require: 'coffee-script/register'
          clearRequireCache: true

  grunt.registerTask 'test', [
    'mochaTest:test'
  ]

  grunt.registerTask 'default', [
    'mochaTest:test'
  ]
