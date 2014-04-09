App.RegisterController = Ember.ObjectController.extend(App.PasswordConfirmMixin,
  username: null
  first_name: null
  last_name: null
  email: null
  password: null
  password2: null
  errors: []
  success: null
  passwordFieldValue: 'password'

  resetForm: ->
    @setProperties
      username: null
      first_name: null
      last_name: null
      email: null
      password: null
      password2: null
      errors: []
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
          @resetForm()
          @set('success', 'Registration was successful!')
      ).fail (jqXHR, status, error) =>
        Ember.run =>
          @resetForm()
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")
)
