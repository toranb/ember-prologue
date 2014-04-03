App.ResetPassConfirmController = Ember.ObjectController.extend
  password1: null
  password2: null
  key: null
  errors: null
  success: null

  resetVars: ->
    @setProperties
      password1: null
      password2: null
      key: null
      errors: null
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
          @set('errors', $.parseJSON(jqXHR.responseText))
