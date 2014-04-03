module "Password reset tests",
  setup: ->
    App.reset()
  teardown: ->
    $.mockjaxClear()

test "Successfully requesting a password reset displays a success message", ->
  mockAjaxResponse("POST", "/api/account/password_reset", {detail: "We emailed instructions to jarrod@gmail.com"}, 200)
  visit "/resetpass"
  andThen ->
    find("#email").attr("value", "jarrod@gmail.com").keyup()
    click("#resetpass-submit-btn")
  andThen ->
    successMessage = find(".alert-info").text().trim()
    equal(successMessage, "We emailed instructions to jarrod@gmail.com")

test "Unsuccessfully requesting a password reset displays an error message", ->
  mockAjaxResponse("POST", "/api/account/password_reset", {email: "Email address not verified for any user amount"}, 400)
  visit "/resetpass"
  andThen ->
    find("#email").attr("value", "bad@pass.com").keyup()
    click("#resetpass-submit-btn")
  andThen ->
    successMessage = find(".alert-danger").text().trim()
    equal(successMessage, "Email address not verified for any user amount")

test "Successfully confirming a password reset request displays a success message", ->
  mockAjaxResponse("POST", "/api/account/password/reset/1-3wd-29e56e9be5486c6f875/", {detail: "Password successfully changed."}, 200)
  visit "/resetpassconfirm/1-3wd-29e56e9be5486c6f875"
  andThen ->
    find("#password1").attr("value", "newPass1").keyup()
    find("#password2").attr("value", "newPass1").keyup()
    click("#resetpassconfirm-submit-btn")
  andThen ->
    successMessage = find(".alert-info").text().trim()
    equal(successMessage, "Password successfully changed.")

test "An error is displayed if you attempt to confirm a password reset and you are already logged in", ->
  mockAjaxResponse("POST", "/api/account/password/reset/1-3wd-29e56e9be5486c6f875/", {detail: "You can't reset your password if you are already authenticated"}, 403)
  visit "/resetpassconfirm/1-3wd-29e56e9be5486c6f875"
  andThen ->
    find("#password1").attr("value", "newPass1").keyup()
    find("#password2").attr("value", "newPass1").keyup()
    click("#resetpassconfirm-submit-btn")
  andThen ->
    successMessage = find(".alert-danger").text().trim()
    equal(successMessage, "You can't reset your password if you are already authenticated")
