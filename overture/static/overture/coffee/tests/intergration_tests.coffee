module "Integration tests",
  setup: ->
    Ember.run ->
      App.reset()

test "New user can successfully login", ->
  tokenResponse = {token: "dcfe0537f11aa142d740217b18c13651b73866ec"}
  getUserResponse = {
    id: 1,
    username: "jrock",
    first_name: "Jarrod",
    last_name: "Taylor",
    email: "jarrod.c.taylor@gmail.com"
  }
  mockAjaxResponse("POST", "/api-token-auth/", tokenResponse)
  mockAjaxResponse("GET", "/api/users/current_user/", getUserResponse)
  visit "/login"
  andThen ->
    fillIn("#login-username", "jrock")
    fillIn("#login-password", "Password")
    click("#login-submit")
  visit "/registered"
  andThen ->
    equal(find("p").text(), "Hello jrock you have successfully signed in.")

