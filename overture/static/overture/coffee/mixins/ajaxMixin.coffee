Ajax = Ember.Mixin.create
  ajaxMixin: (params) ->
    ajaxParams =
      type: params.type or "GET"
      url: params.url
      data: params.data or null
      dataType: "json"
    $.ajax(ajaxParams).done((response) =>
      Ember.run =>
        params.done(response)
    ).fail (jqXHR, status, error) =>
      Ember.run =>
        params.fail(jqXHR, status, error)

`export default Ajax`
