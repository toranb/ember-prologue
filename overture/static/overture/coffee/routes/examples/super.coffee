App.SuperRoute = App.AuthenticatedRoute.extend
  model: ->
    return Ember.$.getJSON('/api/users')
