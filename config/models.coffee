mongoose  = require 'mongoose'

module.exports = ->
  mongoose.model 'BlogPost', require('../models/blogpost')
  mongoose.model 'User', require('../models/user')
  mongoose.model 'LoginToken', require('../models/logintoken')