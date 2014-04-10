Router = Ember.Router.extend()

Router.map ->
  @route("login", {path: "/login"})
  @route("public", {path: "/public"})
  @route("registered", {path: "/registered"})
  @route("super", {path: "/super"})
  @route("register", {path: "/register"})
  @route("resetPass", {path: "/resetpass"})
  @route("resetPassConfirm", {path: "/resetpassconfirm/:reset_key"})
  @route("changePass", {path: "/changepass"})

`export default Router`
