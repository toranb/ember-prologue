App.ResetPassController = Ember.ObjectController.extend
  email: null
  errors: null
  success: null

  resetVars: ->
    @setProperties
      email: null
      errors: null
      success: null

  actions:
    requestReset: ->
      data = @getProperties('email')
      $.ajax(
        type: "POST"
        url: "/api/account/password_reset"
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
