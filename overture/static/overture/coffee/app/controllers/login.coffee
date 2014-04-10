`import Ajax from 'js/app/mixins/ajax'`

LoginController = Ember.ObjectController.extend(Ajax,
  username: null
  password: null
  token: null
  errors: []
  attemptedTransition: null

  resetForm: ->
    @setProperties
      username: null
      password: null
      errors: []

  actions:
    login: ->
      @ajaxMixin
        type: "POST"
        url: "/api-token-auth/"
        data: @getProperties('username', 'password')
        done: (response) =>
          @resetForm()
          @set('token', response.token)
          @getCurrentUser()
        fail: (jqXHR, status, error) =>
          @resetForm()
          theErrors = $.parseJSON(jqXHR.responseText)
          for key, value of theErrors
            @errors.pushObject("#{key.charAt(0).toUpperCase() + key.substring(1)}: #{value}")

  getCurrentUser: ->
    @ajaxMixin
      url: "/api/users/current_user"
      done: (response) =>
        localStorage.setItem("overtureProjectCurrentUserID", response.id)
        @store.push('user', response)
        @preformTransition()
      fail: (jqXHR, status, error) ->
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
)

`export default LoginController`
