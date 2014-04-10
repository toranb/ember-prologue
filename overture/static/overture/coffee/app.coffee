`import Resolver from 'ember/resolver'`

App = Ember.Application.extend
  modulePrefix: 'js',
  Resolver: Resolver['default']
  LOG_TRANSITIONS: false
  LOG_TRANSITIONS_INTERNAL: false

`export default App`
