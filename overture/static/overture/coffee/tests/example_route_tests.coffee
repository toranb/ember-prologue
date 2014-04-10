# ---------------------------------------------------------------------------------- #
# These tests can be removed when you build a real application based off this scaffold
# ---------------------------------------------------------------------------------- #

module "Example route tests",
  setup: ->
    @tokenResponse = {token: "dcfe0537f11aa142d740217b18c13651b73866ec"}
    @user1 = {id: 1, username: "jrock", first_name: "Jarrod", last_name: "Taylor", email: "jarrod@gmail.com"}
  teardown: ->
    $.mockjaxClear()

test "Route that requires login redirects to login and then redirects to the desired route after successful login", ->
  ## This is an example and should be replaced once a real application is developed
  mockAjaxResponse("POST", "/api-token-auth/", @tokenResponse)
  mockAjaxResponse("GET", "/api/users/current_user", @user1)
  visit "/registered"
  andThen ->
    # Should have been redirected to login
    find("#login-username").attr("value", "jrock").keyup()
    find("#login-password").attr("value", "Password").keyup()
    click("#login-submit-btn")
  andThen ->
    equal(find("p").text(), "Hello jrock you have successfully signed in.")
