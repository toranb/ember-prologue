App.LoginController = Ember.ObjectController.extend
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

  loginSuccess: (response) ->
    @reset()
    @set('token', response.token)
    attemptedTransition = @get('attemptedTransition')
    if attemptedTransition
      attemptedTransition.retry()
      @setProperties(attemptedTransition: null)
    else
      @transitionToRoute('index')

  loginError: (jqXHR, status, error) ->
    @set('errors', $.parseJSON(jqXHR.responseText))

  hasToken: (->
    token = @get("token")
    tokenIsEmpty = Ember.isEmpty(token)
    return not tokenIsEmpty and token isnt "null" and token isnt "undefined"
  ).property('token')

  setupAjax: ->
    token = @get("token")
    $(document).ajaxSend (event, xhr, settings) =>
      if @get("hasToken")
        xhr.setRequestHeader("Authorization", "Token #{token}")

  getUserError: (jqXHR, status, error) ->
    console.log(error)

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
