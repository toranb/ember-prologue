App.SuperRoute = App.AuthenticatedRoute.extend
  model: ->
    return @store.find('user')
