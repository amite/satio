crypto    = require 'crypto'
mongoose  = require 'mongoose'
Schema    = mongoose.Schema


validatePresenceOf = (value) ->
  return value && value.length

User = module.exports = new Schema
      email:  { type: String, validate: [validatePresenceOf, 'Email Address is required'], index: { unique: true } }
      name:   String
      hashed_password: String
      salt: String

User.virtual('id')
  .get ->
    return @._id.toHexString()

User.virtual('password')
  .set (pw) ->
    @._password = pw
    @salt = @createSalt()
    @hashed_password = @encryptPassword(pw)
  .get ->
    return @._password

User.method 'authenticate', (plain) ->
  return @encryptPassword(plain) == @hashed_password

User.method 'createSalt', ->
  return Math.round((new Date().valueOf() * Math.random())) + ''

User.method 'encryptPassword', (str) ->
  return crypto.createHmac('sha1', @salt).update(str).digest('hex')

User.pre 'save', (next) ->
  if (!validatePresenceOf(@password))
    next(new Error('Password cannot be blank'))
  else
    next