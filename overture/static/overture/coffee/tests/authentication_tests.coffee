module "Integration tests",
  setup: ->
    App.reset()
    tokenResponse = {token: "dcfe0537f11aa142d740217b18c13651b73866ec"}
    getUserResponse = {
      id: 1,
      username: "jrock",
      first_name: "Jarrod",
      last_name: "Taylor",
      email: "jarrod@gmail.com"
    }
    getUsersResponse = [
      {
        id: 1,
        username: "jrock",
        first_name: "Jarrod",
        last_name: "Taylor",
        email: "jarrod@gmail.com"
      },
      {
        id: 2,
        username: "test",
        first_name: "Tester",
        last_name: "Person",
        email: "test@testing.com"
      }
    ]
    mockAjaxResponse("POST", "/api-token-auth/", tokenResponse)
    mockAjaxResponse("GET", "/api/users/current_user", getUserResponse)
    mockAjaxResponse("GET", "/api/users/", getUsersResponse)
  teardown: ->
    localStorage.clear()

test "Token and current user ID are saved to localStorage after successful login", ->
  visit "/login"
  andThen ->
    fillIn("#login-username", "jrock")
    fillIn("#login-password", "Password")
    click("#login-submit-btn")
  andThen ->
    equal(localStorage.overtureProjectCurrentUserID, 1)
    equal(localStorage.overtureProjectAuthToken, "dcfe0537f11aa142d740217b18c13651b73866ec")

test "Route that requires login redirects to login and then redirects to the desired route after successful login", ->
  ## This is an example and should be replaced once a real application is developed
  visit "/registered"
  andThen ->
    # Should have been redirected to login
    fillIn("#login-username", "jrock")
    fillIn("#login-password", "Password")
    click("#login-submit-btn")
  andThen ->
    equal(find("p").text(), "Hello jrock you have successfully signed in.")

test "Super user can login and access view restricted to super users", ->
  ## This is an example and should be replaced once a real application is developed
  visit "/login"
  andThen ->
    fillIn("#login-username", "jrock")
    fillIn("#login-password", "Password")
    click("#login-submit-btn")
  visit "/super"
  andThen ->
    responseP = find("p").text()
    contains(responseP, 'Jarrod')
    contains(responseP, 'Tester')
