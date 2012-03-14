mongoose  = require 'mongoose'
Schema   = mongoose.Schema

# LoginToken model
# Used for persisting session tokens

LoginToken = module.exports = new Schema
  email: { type: String, index: true }
  series: { type: String, index: true }
  token: { type: String, index: true }


LoginToken.virtual('id')
  .get ->
    return @_id.toHexString()

LoginToken.virtual('cookieValue')
  .get ->
    return JSON.stringify({ email: @email, token: @token, series: @series })

LoginToken.method 'randomToken', ->
  return Math.round((new Date().valueOf() * Math.random())) + ''

LoginToken.pre 'save', (next) ->
  @token = @randomToken()
  @series = @randomToken()