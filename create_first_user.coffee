require('coffee-script')
mongoose = require('mongoose')
controller = {}

module.exports = ->
  return controller

controller.createUser = ->
  dblink = 'mongodb://localhost/satio-blog'
  db  = mongoose.createConnection dblink

  User = db.model('User', require('./models/user'))

  user = new User({ email:'aldo@satio.com.ar', name: 'Aldo Nievas'})
  user.password = 'test'

  user.save(
    (err) ->
      if (!err)
        console.log 'User has been saved'
      else
        console.log 'Failed'
  )
