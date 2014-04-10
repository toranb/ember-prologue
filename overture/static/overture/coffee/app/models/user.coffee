User = DS.Model.extend
  username: DS.attr('string')
  first_name: DS.attr('string')
  last_name: DS.attr('string')
  email: DS.attr('string')

`export default User`
