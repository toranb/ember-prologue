ApplicationController = Ember.ObjectController.extend
  mobileMenuVisible: false
  needs: 'login'
  actions:
    toggleMobileMenu: ->
      @toggleProperty('mobileMenuVisible')
      @pushBody()

  pushBody: ->
    $('body').toggleClass("push-mobile-nav-right")

`export default ApplicationController`
