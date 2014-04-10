ResetPassRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @._super(controller, model)
    @controllerFor('resetPass').resetForm()

`export default ChangePassRoute`
