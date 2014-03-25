App.RegisterController = Ember.ObjectController.extend
  username: null
  first_name: null
  last_name: null
  email: null
  password: null
  password2: null
  passwordError: null
  errors: null

  getValue: (formField) ->
    passwordValue = @get('password')
    password2Value = @get(formField)
    if passwordValue != password2Value
      @set('passwordError', 'Passwords do not match.')
    else
      @set('passwordError', '')

  validatePassword: ->
    @getValue('password2')

  actions:
    createUser: ->
      data = @getProperties('username', 'first_name', 'last_name', 'email', 'password')
      $.ajax(
        type: "POST"
        url: "/api/users/"
        data: data
        dataType: "json"
      ).done((response) ->
        Ember.run ->
          console.log('We should have a new user now')
      ).fail (jqXHR, status, error) =>
        Ember.run =>
          @set('errors', $.parseJSON(jqXHR.responseText))
