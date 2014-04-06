App.PasswordConfirmField = Ember.TextField.extend
  keyUp: (event) ->
    controller = @get('parentView.controller')    # We do not know the controller by default
    controller["validatePassword"]()              # Call the validatePassword function in controller
