`import PasswordConfirmMixin from 'js/app/mixins/password-confrim'`
`import Ajax from 'js/app/mixins/ajax'`

RegisterController = Ember.ObjectController.extend(PasswordConfirmMixin, Ajax,
  username: null
  first_name: null
  last_name: null
  email: null
  password: null
  password2: null
  errors: []
  success: null
  passwordFieldValue: 'password'

  resetForm: ->
    @setProperties
      username: null
      first_name: null
      last_name: null
      email: null
      password: null
      password2: null
      errors: []
      success: null

  actions:
    createUser: ->
      @ajaxMixin
        type: "POST"
        url: "/api/users/"
        data: @getProperties('username', 'first_name', 'last_name', 'email', 'password')
        done: (response) =>
          @resetForm()
          @set('success', 'Registration was successful!')
        fail: (jqXHR, status, error) =>
          @resetForm()
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")
)

`export default RegisterController`
