App.RegisteredRoute = App.AuthenticatedRoute.extend
  model: ->
    return @store.find('user', "current_user")
