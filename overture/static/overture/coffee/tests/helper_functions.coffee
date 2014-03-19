mockAjaxResponse = (verb, url, json, status=200) ->
  $.mockjax
    type: verb
    url: url
    status: status
    dataType: "json"
    responseText: json

$.mockjaxSettings.logging = false
$.mockjaxSettings.responseTime = 0
