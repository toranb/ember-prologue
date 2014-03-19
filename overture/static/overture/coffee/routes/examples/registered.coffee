App.RegisteredRoute = App.AuthenticatedRoute.extend
  model: ->
    return Ember.$.getJSON('/api/users/current_user')

