App.ChangepassController = Ember.ObjectController.extend
  current_password: null
  password1: null
  password2: null
  passwordError: null
  errors: null
  success: null

  resetVars: ->
    @setProperties
      current_password: null
      password1: null
      password2: null
      passwordError: null
      errors: null
      success: null

  getValue: (formField) ->
    passwordValue = @get('password1')
    password2Value = @get(formField)
    if passwordValue != password2Value
      @set('passwordError', 'Passwords do not match.')
    else
      @set('passwordError', '')

  validatePassword: ->
    @getValue('password2')

  actions:
    changePass: ->
      data = @getProperties('current_password', 'password1', 'password2')
      $.ajax(
        type: "POST"
        url: "/api/account/password_change"
        data: data
        dataType: "json"
      ).done((response) =>
        Ember.run =>
          @resetVars()
          @set('success', response.detail)
      ).fail (jqXHR, status, error) =>
        Ember.run =>
          @resetVars()
          @set('errors', $.parseJSON(jqXHR.responseText))
