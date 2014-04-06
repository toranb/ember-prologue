App.ResetPassController = Ember.ObjectController.extend
  email: null
  errors: []
  success: null

  resetVars: ->
    @setProperties
      email: null
      errors: []
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
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")
