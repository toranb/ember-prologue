`import Application from 'js/app/app'`
`import Router from 'js/app/router'`

startApp ->
  App = undefined
  attributes
    rootElement: "#ember-testing"
    LOG_ACTIVE_GENERATION: false
    LOG_VIEW_LOOKUPS: false
  Router.reopen
    location: "none"
  Ember.run ->
    App = Application.create(attributes)
    App.setupForTesting()
    App.injectTestHelpers()
    return

  App.reset()
  return App

`export default startApp`
