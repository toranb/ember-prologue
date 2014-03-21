App.RegisteredRoute = App.AuthenticatedRoute.extend
  model: ->
    return @store.find('user', localStorage.overtureProjectCurrentUserID)
