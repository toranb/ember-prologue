module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-concat")
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-contrib-watch")
  grunt.loadNpmTasks("grunt-ember-template-compiler")
  grunt.loadNpmTasks("grunt-karma")
  grunt.loadNpmTasks("grunt-contrib-less")
  grunt.initConfig
    coffee:
      options:
        bare: true
      compile:
        files:
          'overture/static/overture/js/app.min.js': [
            'overture/static/overture/coffee/app.coffee'
            'overture/static/overture/coffee/routes/router.coffee'
            'overture/static/overture/coffee/routes/application.coffee'
            'overture/static/overture/coffee/routes/authenticated.coffee'
            'overture/static/overture/coffee/routes/examples/registered.coffee'
            'overture/static/overture/coffee/routes/examples/super.coffee'
            'overture/static/overture/coffee/controllers/application.coffee'
            'overture/static/overture/coffee/controllers/login.coffee'
            'overture/static/overture/coffee/controllers/register.coffee'
            'overture/static/overture/coffee/views/register.coffee'
            'overture/static/overture/coffee/models/models.coffee'
          ]
          'overture/static/overture/js/tests/tests.min.js': 'overture/static/overture/coffee/tests/*.coffee'

    less:
      build:
        files:
          "overture/static/overture/css/navbar.css": "overture/static/overture/less/navbar.less"
          "overture/static/overture/css/authentication.css": "overture/static/overture/less/authentication.less"
          "overture/static/overture/css/overture.css": "overture/static/overture/less/overture.less"

    watch:
      options:
        livereload: true,
        debounceDelay: 100
      sources:
        files: [
          "overture/static/overture/css/*.less"
          "overture/static/overture/js/templates/*.handlebars"
          "overture/static/overture/coffee/*.coffee"
        ]
        tasks: ["build"]

    karma:
      unit:
        configFile: "karma.conf.js"

    concat:
      dist:
        src: [
          "overture/static/overture/js/vendor/jquery/dist/jquery.min.js"
          "overture/static/overture/js/vendor/handlebars/handlebars.js"
          "overture/static/overture/js/vendor/ember/ember.js"
          "overture/static/overture/js/vendor/ember-data/ember-data.js"
          "overture/static/overture/js/vendor/ember-data-django-rest-adapter/build/ember-data-django-rest-adapter.min.js"
          "overture/static/overture/js/app.min.js"
          "overture/static/overture/js/lib/templates.min.js"
        ]
        dest: "overture/static/overture/js/lib/scripts.min.js"

      test:
        src: [
          "overture/static/overture/js/vendor/jquery/dist/jquery.min.js"
          "overture/static/overture/js/vendor/handlebars/handlebars.js"
          "overture/static/overture/js/vendor/ember/ember.js"
          "overture/static/overture/js/vendor/ember-data/ember-data.js"
          "overture/static/overture/js/vendor/ember-data-django-rest-adapter/build/ember-data-django-rest-adapter.min.js"
          "overture/static/overture/js/vendor/jquery-mockjax/jquery.mockjax.js"
          "overture/static/overture/js/app.min.js"
          "overture/static/overture/js/lib/templates.min.js"
          "overture/static/overture/js/tests/tests.min.js"
        ]
        dest: "overture/static/overture/js/lib/scripts.min.js"

      css:
        src: [
          "overture/static/overture/css/navbar.css"
          "overture/static/overture/css/authentication.css"
          "overture/static/overture/css/overture.css"
        ]
        dest: "overture/static/overture/css/overture.min.css"

    emberhandlebars:
      compile:
        options:
          templateName: (sourceFile) ->
            newSource = sourceFile.replace("overture/static/overture/js/templates/", "")
            newSource.replace ".handlebars", ""

        files: ["overture/static/overture/js/templates/*.handlebars"]
        dest: "overture/static/overture/js/lib/templates.min.js"

  grunt.task.registerTask("build", ["coffee", "emberhandlebars", "less:build", "concat:dist", "concat:css"])
  grunt.task.registerTask("test", ["coffee", "emberhandlebars", "less:build", "concat:test", "concat:css", "karma"])
