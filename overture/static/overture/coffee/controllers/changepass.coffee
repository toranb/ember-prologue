App.ChangePassController = Ember.ObjectController.extend(App.PasswordConfirmMixin,
  current_password: null
  password1: null
  password2: null
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
)
