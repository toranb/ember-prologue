module "Registration tests",
  setup: ->
  teardown: ->
    $.mockjaxClear()

test "Error is shown while passwords do not match on registration screen", ->
  visit "/register"
  andThen ->
    find("#register-password").attr("value", "Password").keyup()
    find("#register-password2").attr("value", "Passw").keyup()
    find("#register-password2").keyup()
    errorMessage = find(".password-error").text().trim()
    equal(errorMessage, "Passwords do not match.")

test "No error is shown when passwords do match on registration screen", ->
  visit "/register"
  andThen ->
    find("#register-password").attr("value", "Password").keyup()
    find("#register-password2").attr("value", "Password").keyup()
    find("#register-password2").keyup()
    errorMessage = find(".password-error").text().trim()
    equal(errorMessage, "")

test "Trying to register a user with an already existing username displays an error on registration screen", ->
  mockAjaxResponse("POST", "/api/users/", {username: ["User with this Username already exists."]}, 400)
  visit "/register"
  andThen ->
    click("#register-submit-btn")
  andThen ->
    errorMessage = find(".alert-danger").text().trim()
    equal(errorMessage, "Username: User with this Username already exists.")

test "Trying to register a user with an already existing email address displays an error on registration screen", ->
  mockAjaxResponse("POST", "/api/users/", {detail: ["That email address is already registered"]}, 400)
  visit "/register"
  andThen ->
    click("#register-submit-btn")
  andThen ->
    errorMessage = find(".alert-danger").text().trim()
    equal(errorMessage, "Detail: That email address is already registered")

test "Trying to register a user with no password displays an error on registration screen", ->
  mockAjaxResponse("POST", "/api/users/", {password: ["This field is required."]}, 400)
  visit "/register"
  andThen ->
    click("#register-submit-btn")
  andThen ->
    errorMessage = find(".alert-danger").text().trim()
    equal(errorMessage, "Password: This field is required.")
