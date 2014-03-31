App.ApplicationRoute = Ember.Route.extend
  init: ->
    # Remembered user if they close their browser
    @_super()
    @controllerFor("login").set("token", localStorage.overtureProjectAuthToken)
    @controllerFor("login").setupAjax()

  actions:
    logout: ->
      @controllerFor("login").set("token", null)
      localStorage.overtureProjectCurrentUserID = null
      if @controllerFor("application").get("mobileMenuVisible")
        @controllerFor("application").set("mobileMenuVisible", false)
        @controllerFor("application").pushBody()
      @transitionTo("index")
