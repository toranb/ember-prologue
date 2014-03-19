App.AuthenticatedRoute = Ember.Route.extend
  actions:
    error: (error, transition) ->
      console.log("Error status: #{error.status}")
      loginController = @controllerFor('login')
      @controllerFor("login").set('attemptedTransition', transition)
      @transitionTo('login')

