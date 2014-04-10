`import Ajax from 'js/app/mixins/ajax'`
`import PasswordConfirmMixin from 'js/app/mixins/password-confirm'`

ResetPassConfirmController = Ember.ObjectController.extend(PasswordConfirmMixin, Ajax,
  password1: null
  password2: null
  key: null
  errors: []
  success: null

  resetForm: ->
    @setProperties
      password1: null
      password2: null
      key: null
      errors: []
      success: null

  actions:
    resetConfrim: ->
      @ajaxMixin
        type: "POST"
        url: "/api/account/password/reset/#{@get('key')}/"
        data: @getProperties('password1', 'password2')
        done: (response) =>
          @resetForm()
          @set('success', response.detail)
        fail: (jqXHR, status, error) =>
          @resetForm()
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")
)

`export default ResetPassConfirmController`
