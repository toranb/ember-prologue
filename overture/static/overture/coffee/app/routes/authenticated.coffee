AuthenticatedRoute = Ember.Route.extend
  beforeModel: (transition) ->
    if not @controllerFor('login').get('hasToken')
      @redirectToLogin(transition)

  redirectToLogin: (transition) ->
    loginController = @controllerFor('login')
    @controllerFor("login").set('attemptedTransition', transition)
    @transitionTo('login')

  actions:
    error: (error, transition) ->
      console.log("Error status: #{error.status}")
      @redirectToLogin(transition)

`export default AuthenticatedRoute`
