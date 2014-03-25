module "Integration tests",
  setup: ->
    App.reset()
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
    equal(errorMessage, "Unable to login with provided credentials.")

test "Error is shown while passwords do not match on registration screen", ->
  visit "/register"
  andThen ->
    find("#register-password").attr("value", "Password").keyup()
    find("#register-password2").attr("value", "Passw").keyup()
    find("#register-password2").keyup()
    errorMessage = find("#register-password-error").text().trim()
    equal(errorMessage, "Passwords do not match.")

test "No error is shown when passwords do match on registration screen", ->
  visit "/register"
  andThen ->
    find("#register-password").attr("value", "Password").keyup()
    find("#register-password2").attr("value", "Password").keyup()
    find("#register-password2").keyup()
    password = find("#register-password")
    password2 = find("#register-password2")
    errorMessage = find("#register-password-error").text().trim()
    equal(errorMessage, "")

test "Trying to register a user with an already existing password displays an error on registration screen", ->
  mockAjaxResponse("POST", "/api/users/", {username: ["User with this Username already exists."]}, 400)
  visit "/register"
  andThen ->
    click("#register-submit-btn")
  andThen ->
    missing(".registration-password-error")
    errorMessage = find(".registration-username-error").text().trim()
    equal(errorMessage, "Username: User with this Username already exists.")

test "Trying to register a user with no password displays an error on registration screen", ->
  mockAjaxResponse("POST", "/api/users/", {password: ["This field is required."]}, 400)
  visit "/register"
  andThen ->
    click("#register-submit-btn")
  andThen ->
    missing(".registration-username-error")
    errorMessage = find(".registration-password-error").text().trim()
    equal(errorMessage, "Password: This field is required.")

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
