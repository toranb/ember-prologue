App.LoginController = Ember.ObjectController.extend
  id: null
  username: null
  password: null
  token: null
  errors: null
  attemptedTransition: null

  reset: ->
    @setProperties
      username: null
      password: null
      errors: null

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

  loginSuccess: (response) ->
    @reset()
    @set('token', response.token)
    @getCurrentUser()

  loginError: (jqXHR, status, error) ->
    @set('errors', $.parseJSON(jqXHR.responseText))

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

  getUserSuccess: (response) ->
    localStorage.setItem("overtureProjectCurrentUserID", response.id)
    @set('id', response.id)
    @store.push('user', response)
    @preformTransition()

  getUserError: (jqXHR, status, error) ->
    console.log(error)

  preformTransition: ->
    attemptedTransition = @get('attemptedTransition')
    if attemptedTransition
      attemptedTransition.retry()
      @setProperties(attemptedTransition: null)
    else
      @transitionToRoute('index')

  hasToken: (->
    token = @get("token")
    tokenIsEmpty = Ember.isEmpty(token)
    return not tokenIsEmpty and token isnt "null" and token isnt "undefined"
  ).property('token')

  tokenChanged: (->
    localStorage.overtureProjectAuthToken = @get("token")
    @setupAjax()
  ).observes("token")

  setupAjax: ->
    token = @get("token")
    $(document).ajaxSend (event, xhr, settings) =>
      if @get("hasToken")
        xhr.setRequestHeader("Authorization", "Token #{token}")

