App.ResetPassConfirmController = Ember.ObjectController.extend(App.PasswordConfirmMixin,
  password1: null
  password2: null
  key: null
  errors: []
  success: null

  resetVars: ->
    @setProperties
      password1: null
      password2: null
      key: null
      errors: []
      success: null

  actions:
    resetConfrim: ->
      data = @getProperties('password1', 'password2')
      $.ajax(
        type: "POST"
        url: "/api/account/password/reset/#{@get('key')}/"
        data: data
        dataType: 'json'
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
