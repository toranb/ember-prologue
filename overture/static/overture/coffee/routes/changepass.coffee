ChangePassRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @._super(controller, model)
    @controllerFor('changePass').resetForm()

`export default ChangePassRoute`
