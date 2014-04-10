module "Login tests",
  setup: ->
    @tokenResponse = {token: "dcfe0537f11aa142d740217b18c13651b73866ec"}
    @user1 = {id: 1, username: "jrock", first_name: "Jarrod", last_name: "Taylor", email: "jarrod@gmail.com"}
  teardown: ->
    localStorage.clear()
    $.mockjaxClear()

test "Token and current user ID are saved to localStorage after successful login", ->
  mockAjaxResponse("POST", "/api-token-auth/", @tokenResponse)
  mockAjaxResponse("GET", "/api/users/current_user", @user1)
  visit "/login"
  andThen ->
    find("#login-username").attr("value", "jrock").keyup()
    find("#login-password").attr("value", "Password").keyup()
    click("#login-submit-btn")
  andThen ->
    equal(localStorage.overtureProjectCurrentUserID, 1)
    equal(localStorage.overtureProjectAuthToken, "dcfe0537f11aa142d740217b18c13651b73866ec")

test "Error message is displayed after a unsuccessful login attempt", ->
  mockAjaxResponse("POST", "/api-token-auth/", {non_field_errors: 'Unable to login with provided credentials.'}, 400)
  visit "/login"
  andThen ->
    find("#login-username").attr("value", "jrock").keyup()
    find("#login-password").attr("value", "Password").keyup()
    click("#login-submit-btn")
  andThen ->
    errorMessage = find(".alert").text().trim()
    equal(errorMessage, "Non_field_errors: Unable to login with provided credentials.")
