# -- Models
App.ApplicationAdapter = DS.DjangoRESTAdapter.extend
  namespace: 'api'

App.Store = DS.Store.extend
  adapter: DS.RESTAdapter

App.User = DS.Model.extend
  username: DS.attr('string')
  first_name: DS.attr('string')
  last_name: DS.attr('string')
  email: DS.attr('string')
