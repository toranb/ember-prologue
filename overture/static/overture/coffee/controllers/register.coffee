App.RegisterController = Ember.ObjectController.extend(App.PasswordConfirmMixin,
  username: null
  first_name: null
  last_name: null
  email: null
  password: null
  password2: null
  errors: null
  success: null
  passwordFieldValue: 'password'

  resetVars: ->
    @setProperties
      username: null
      first_name: null
      last_name: null
      email: null
      password: null
      password2: null
      errors: null
      success: null

  actions:
    createUser: ->
      data = @getProperties('username', 'first_name', 'last_name', 'email', 'password')
      $.ajax(
        type: "POST"
        url: "/api/users/"
        data: data
        dataType: "json"
      ).done((response) =>
        Ember.run =>
          @resetVars()
          @set('success', 'Registration was successful!')
      ).fail (jqXHR, status, error) =>
        Ember.run =>
          @resetVars()
          @set('errors', $.parseJSON(jqXHR.responseText))
)
