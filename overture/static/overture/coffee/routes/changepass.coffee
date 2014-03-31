App.ChangepassRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @._super(controller, model)
    @controllerFor('changepass').resetVars()
