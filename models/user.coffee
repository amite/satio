mongoose  = require 'mongoose'
Schema    = mongoose.Schema

module.exports.Post = mongoose.model 'User', new Schema({
  email: {
    type: Email,
    validate: [required, 'Email is required'],
    index: { unique: true }
  },
  hexdigest: {
    type: String,
    validate: [required, 'Password is required'],
    match: /[A-Za-z0-9]{12}\$[0-9a-f]{32}/
  },
  active: {
    type: Boolean,
    'default': false
  },
  createdAt: {
    type: Date,
    'default': Date.now
  }
})