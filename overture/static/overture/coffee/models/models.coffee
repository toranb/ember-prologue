# -- Models
ApplicationAdapter = DS.DjangoRESTAdapter.extend
  namespace: 'api'

Store = DS.Store.extend
  adapter: DS.RESTAdapter

User = DS.Model.extend
  username: DS.attr('string')
  first_name: DS.attr('string')
  last_name: DS.attr('string')
  email: DS.attr('string')


`export default ApplicationAdapter`
`export default Store`
`export default User`
