`import Ajax from 'js/app/mixins/ajax'`

ResetPassController = Ember.ObjectController.extend(Ajax,
  email: null
  errors: []
  success: null

  resetForm: ->
    @setProperties
      email: null
      errors: []
      success: null

  actions:
    requestReset: ->
      @ajaxMixin
        type: "POST"
        url: "/api/account/password_reset"
        data: @getProperties('email')
        done: (response) =>
          @resetForm()
          @set('success', response.detail)
        fail: (jqXHR, status, error) =>
          @resetForm()
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")
)

`export default ResetPassController`
