mongoose 	= require 'mongoose'
Schema    = mongoose.Schema

#models
module.exports.Comment = mongoose.model 'Comment', new Schema({
  body: String,
  date: { type: Date, default: Date.now }
}, { collection : 'posts' })
