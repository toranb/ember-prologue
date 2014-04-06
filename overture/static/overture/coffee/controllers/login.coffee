App.LoginController = Ember.ObjectController.extend
  username: null
  password: null
  token: null
  errors: []
  attemptedTransition: null

  reset: ->
    @setProperties
      username: null
      password: null
      errors: []

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
          @reset()
          @set('token', response.token)
          @getCurrentUser()
      ).fail (jqXHR, status, error) =>
        Ember.run =>
          @reset()
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")

  getCurrentUser: ->
    $.ajax(
      type: "GET"
      url: "/api/users/current_user"
      dataType: "json"
    ).done((response) =>
      Ember.run =>
        localStorage.setItem("overtureProjectCurrentUserID", response.id)
        @store.push('user', response)
        @preformTransition()
    ).fail (jqXHR, status, error) ->
      Ember.run ->
        console.log(error)

  preformTransition: ->
    attemptedTransition = @get('attemptedTransition')
    if attemptedTransition
      attemptedTransition.retry()
      @setProperties(attemptedTransition: null)
    else
      @transitionToRoute('index')

  tokenChanged: (->
    localStorage.overtureProjectAuthToken = @get("token")
    @setupAjax()
  ).observes("token")

  setupAjax: ->
    token = @get("token")
    $(document).ajaxSend (event, xhr, settings) =>
      if @get("hasToken")
        xhr.setRequestHeader("Authorization", "Token #{token}")

  hasToken: (->
    token = @get("token")
    tokenIsEmpty = Ember.isEmpty(token)
    return not tokenIsEmpty and token isnt "null" and token isnt "undefined"
  ).property('token')
