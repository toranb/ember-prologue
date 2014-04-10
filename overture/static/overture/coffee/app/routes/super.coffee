`import AuthenticatedRoute from 'js/app/routes/authenticated'`

SuperRoute = AuthenticatedRoute.extend
  model: ->
    return @store.find('user')

`export default SuperRoute`
