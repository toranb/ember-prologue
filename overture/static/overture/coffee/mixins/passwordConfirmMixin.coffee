App.PasswordConfirmMixin = Ember.Mixin.create
  passwordError: null
  passwordFieldValue: 'password1'

  validatePassword: ->
    passwordValue = @get(@passwordFieldValue)
    password2Value = @get('password2')
    if passwordValue != password2Value
      @set('passwordError', 'Passwords do not match.')
    else
      @set('passwordError', '')
