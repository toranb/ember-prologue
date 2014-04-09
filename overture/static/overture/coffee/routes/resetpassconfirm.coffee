App.ResetPassConfirmRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @._super(controller, model)
    @controllerFor('resetPassConfirm').resetForm()
    @controllerFor("resetPassConfirm").set("key", model.reset_key)
