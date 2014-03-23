mockAjaxResponse = (verb, url, json, status=200) ->
  $.mockjax
    type: verb
    url: url
    status: status
    dataType: "json"
    responseText: json

$.mockjaxSettings.logging = false
$.mockjaxSettings.responseTime = 0

contains = (haystack, needle, message) ->
  actual = haystack.indexOf(needle) != -1
  QUnit.push actual, needle, haystack, message

notContains = (haystack, needle, message) ->
  actual = haystack.indexOf(needle) == -1
  QUnit.push actual, needle, haystack, message

exists = (selector) ->
  !!find(selector).length

missing = (selector) ->
  error = "element " + selector + " found (should be missing)"
  element = find(selector).length
  equal(0, element, error)
