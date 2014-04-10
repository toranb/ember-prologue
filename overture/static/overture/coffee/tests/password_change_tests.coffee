module "Password change tests",
  setup: ->
  teardown: ->
    $.mockjaxClear()

test "Successfully changing your password displays a success message", ->
  mockAjaxResponse("POST", "/api/account/password_change", {detail: "Password successfully changed"}, 200)
  visit "/changepass"
  andThen ->
    find("#change-pass-old-password").attr("value", "oldPass").keyup()
    find("#change-pass-new-password").attr("value", "newPass").keyup()
    find("#change-pass-new-password2").attr("value", "newPass").keyup()
    click("#changepass-submit-btn")
  andThen ->
    successMessage = find(".alert-info").text().trim()
    equal(successMessage, "Password successfully changed")

test "An error is displayed when a user submits a change password form with passwords that do not match", ->
  mockAjaxResponse("POST", "/api/account/password_change", {password2: "Password confirmation mismatch"}, 400)
  visit "/changepass"
  andThen ->
    find("#change-pass-old-password").attr("value", "oldPass").keyup()
    find("#change-pass-new-password").attr("value", "newPass").keyup()
    find("#change-pass-new-password2").attr("value", "XnewPassX").keyup()
    click("#changepass-submit-btn")
  andThen ->
    successMessage = find(".alert-danger").text().trim()
    equal(successMessage, "Password2: Password confirmation mismatch")

test "Error is shown while passwords do not match on change password screen", ->
  visit "/changepass"
  andThen ->
    find("#change-pass-new-password").attr("value", "Password").keyup()
    find("#change-pass-new-password2").attr("value", "Passw").keyup()
    find("#change-pass-new-password2").keyup()
    errorMessage = find(".password-error").text().trim()
    equal(errorMessage, "Passwords do not match.")

test "No error is shown when passwords do match on change password screen", ->
  visit "/changepass"
  andThen ->
    find("#change-pass-new-password").attr("value", "Password").keyup()
    find("#change-pass-new-password2").attr("value", "Password").keyup()
    find("#change-pass-new-password2").keyup()
    password = find("#register-password")
    password2 = find("#register-password2")
    errorMessage = find(".password-error").text().trim()
    equal(errorMessage, "")
