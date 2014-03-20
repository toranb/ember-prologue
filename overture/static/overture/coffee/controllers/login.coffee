App.LoginController = Ember.ObjectController.extend
  username: null
  password: null
  token: null
  errors: null
  attemptedTransition: null

  reset: ->
    Ember.run =>
      @setProperties
        username: null
        password: null
        errors: null

  loginSuccess: (response) ->
    Ember.run =>
      @reset()
      @set('token', response.token)
      @getCurrentUser()
      attemptedTransition = @get('attemptedTransition')
      if attemptedTransition
        attemptedTransition.retry()
        @setProperties(attemptedTransition: null)
      else
        @transitionToRoute('index')

  loginError: (jqXHR, status, error) ->
    Ember.run =>
      @set('errors', $.parseJSON(jqXHR.responseText))

  hasToken: (->
    Ember.run =>
      token = @get("token")
      tokenIsEmpty = Ember.isEmpty(token)
      return not tokenIsEmpty and token isnt "null" and token isnt "undefined"
  ).property('token')

  setupAjax: ->
    Ember.run =>
      token = @get("token")
      $(document).ajaxSend (event, xhr, settings) =>
        if @get("hasToken")
          xhr.setRequestHeader("Authorization", "Token #{token}")

  getUserSuccess: (response) ->
    Ember.run =>
      @store.push('user', response)

  getUserError: (jqXHR, status, error) ->
    console.log(error)

  getCurrentUser: ->
    $.ajax(
      type: "GET"
      url: "/api/users/current_user"
      dataType: "json"
    ).done((response) =>
      Ember.run =>
        @getUserSuccess(response)
    ).fail (jqXHR, status, error) =>
      Ember.run =>
        @getUserError(jqXHR, status, error)

  tokenChanged: (->
    localStorage.overtureProjectAuthToken = @get("token")
    @setupAjax()
  ).observes("token")

  actions:
    login: ->
      data = @getProperties('username', 'password')
      $.ajax(
        type: "POST"
        url: "/api-token-auth/"
        data: data
        dataType: "json"
      ).done((response) =>
        Ember.run =>
          @loginSuccess(response)
      ).fail (jqXHR, status, error) =>
        Ember.run =>
          @loginError(jqXHR, status, error)

