App.ChangePassController = Ember.ObjectController.extend(App.PasswordConfirmMixin,
  current_password: null
  password1: null
  password2: null
  errors: []
  success: null

  resetVars: ->
    @setProperties
      current_password: null
      password1: null
      password2: null
      passwordError: null
      errors: []
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
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")
)
