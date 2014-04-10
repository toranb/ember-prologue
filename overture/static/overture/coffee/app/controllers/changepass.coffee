`import PasswordConfrimMixin from 'js/app/mixins/password-confirm'`
`import Ajax from 'js/app/mixins/ajax'`

ChangePassController = Ember.ObjectController.extend(PasswordConfirmMixin, Ajax,
  current_password: null
  password1: null
  password2: null
  errors: []
  success: null

  resetForm: ->
    @setProperties
      current_password: null
      password1: null
      password2: null
      passwordError: null
      errors: []
      success: null

  actions:
    changePass: ->
      @ajaxMixin
        type: "POST"
        url: "/api/account/password_change"
        data: @getProperties('current_password', 'password1', 'password2')
        done: (response) =>
          @resetForm()
          @set('success', response.detail)
        fail: (jqXHR, status, error) =>
          @resetForm()
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")
)

`export default ChangePassController`
