`import AuthenticatedRoute from 'coffee/routes/authenticated'`

RegisteredRoute = AuthenticatedRoute.extend
  model: ->
    return @store.find('user', localStorage.overtureProjectCurrentUserID)

`export default RegisteredRoute`
