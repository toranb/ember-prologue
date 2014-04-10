`import AuthenticatedRoute from 'coffee/routes/authenticated'`

SuperRoute = AuthenticatedRoute.extend
  model: ->
    return @store.find('user')

`export default SuperRoute`
