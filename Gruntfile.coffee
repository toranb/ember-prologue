module.exports = (grunt) ->
  grunt.loadNpmTasks("grunt-contrib-concat")
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-contrib-watch")
  grunt.loadNpmTasks("grunt-ember-template-compiler")
  grunt.loadNpmTasks('grunt-contrib-testem')
  grunt.loadNpmTasks("grunt-contrib-less")
  grunt.initConfig
    coffee:
      options:
        bare: true
      compile:
        files:
          'overture/static/overture/js/app.min.js': [
            'overture/static/overture/coffee/app.coffee'
            'overture/static/overture/coffee/mixins/*.coffee'
            'overture/static/overture/coffee/routes/*.coffee'
            'overture/static/overture/coffee/routes/examples/*.coffee'
            'overture/static/overture/coffee/controllers/*.coffee'
            'overture/static/overture/coffee/views/*.coffee'
            'overture/static/overture/coffee/components/*.coffee'
            'overture/static/overture/coffee/models/*.coffee'
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
          "overture/static/overture/templates/*.handlebars"
          "overture/static/overture/coffee/*.coffee"
        ]
        tasks: ["build"]

    testem:
      basic:
        src: [
          "node_modules/qunit-special-blend/qunit-special-blend.js"
          "overture/static/overture/js/lib/scripts.min.js"
          "node_modules/qunit-special-blend/run-qunit-special-blend.js"
        ]
        options:
          parallel: 2,
          framework: "qunit",
          launch_in_dev: ["PhantomJS"]
          launch_in_ci: ["PhantomJS"]

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
            newSource = sourceFile.replace("overture/static/overture/templates/", "")
            newSource.replace ".handlebars", ""

        files: ["overture/static/overture/templates/*.handlebars"]
        dest: "overture/static/overture/js/lib/templates.min.js"

  grunt.task.registerTask("build", ["coffee", "emberhandlebars", "less:build", "concat:dist", "concat:css"])
  grunt.task.registerTask("test", ["coffee", "emberhandlebars", "less:build", "concat:test", "concat:css", "testem:basic"])
