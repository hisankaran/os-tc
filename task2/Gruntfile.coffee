fs = require('fs')

module.exports = (grunt) ->

  for key of grunt.file.readJSON('package.json').devDependencies
    if key isnt 'grunt' and key.indexOf('grunt') is 0
      grunt.loadNpmTasks key

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      options:
        bare: true
        sourceMap: true
      src:
        files: [
          expand: true
          cwd: 'src/'
          src: [ '**/*.coffee' ]
          dest: 'app/'
          ext: '.js'
        ]

    watch:
      src:
        files: [ 'src/**/*' ]
        tasks: [
          'build:app'
        ]
        options:
          spawn: false

    'node-inspector':
      app:
        options:
          hidden: ['node_modules']

    nodemon:
      app:
        script: 'app/server.js'
        options:
          ignore: ['node_modules/**'],
          ext: 'js,coffee'
          nodeArgs: ['--debug']

    concurrent:
      dev:
        tasks: ['watch:src', 'nodemon:app']
        options:
          logConcurrentOutput: true

    mochaTest:
      test:
        src: ['test/**/*.coffee']
        options:
          require: 'coffee-script/register'
          clearRequireCache: true

  grunt.registerTask 'default', [
    'build'
  ]

  grunt.registerTask 'build', [
    'build:app'
  ]

  grunt.registerTask 'build:app', [
    'coffee:src'
  ]

  grunt.registerTask 'test', [
    'mochaTest:test'
  ]

  grunt.registerTask 'dev', [
    'build:app'
    'concurrent:dev'
  ]